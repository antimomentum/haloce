#include <arpa/inet.h>
#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/udp.h>

#define SEC(NAME) __attribute__((section(NAME), used))
#define IP_FRAGMENTED 65343

SEC("prog")
int xdp_func(struct xdp_md *ctx)
{
    void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;
    unsigned char match_pattern[] = {0x74, 0x65, 0x73, 0x74};
    unsigned int payload_size, i;
    struct ethhdr *eth = data;
    unsigned char *payload;
    struct udphdr *udp;
    struct iphdr *ip;

    if ((void *)eth + sizeof(*eth) > data_end)
        return XDP_PASS;

    ip = data + sizeof(*eth);
    if ((void *)ip + sizeof(*ip) > data_end)
        return XDP_PASS;

    if (ip->protocol != IPPROTO_UDP)
        return XDP_PASS;

    udp = (void *)ip + sizeof(*ip);
    if ((void *)udp + sizeof(*udp) > data_end)
        return XDP_PASS;

    if (udp->dest != ntohs(5005))
        return XDP_PASS;

    payload_size = ntohs(udp->len) - sizeof(*udp);
    if (payload_size != sizeof(match_pattern)) 
        return XDP_PASS;

    // Point to start of payload.
    payload = (unsigned char *)udp + sizeof(*udp);
    if ((void *)payload + payload_size > data_end)
        return XDP_PASS;

    // Compare each byte, exit if a difference is found.
    for (i = 0; i < payload_size; i++)
        if (payload[i] != match_pattern[i])
            return XDP_PASS;

    // Same payload, drop.
    return XDP_DROP;
}
