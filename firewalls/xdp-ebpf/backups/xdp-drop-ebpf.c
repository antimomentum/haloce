#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/in.h>
#include <linux/ip.h>
#include <linux/ipv6.h>
#include <linux/udp.h>
#include <linux/tcp.h>
#include <stdint.h>

#define SEC(NAME) __attribute__((section(NAME), used))

#define htons(x) ((__be16)___constant_swab16((x)))

#define IP_FRAGMENTED 65343

SEC("prog")
int xdp_drop_benchmark_traffic(struct xdp_md *ctx)
{
    void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;
    struct ethhdr *eth = data;

    uint64_t nh_off = sizeof(*eth);
    if (data + nh_off > data_end)
    {
        return XDP_PASS;
    }

    uint16_t h_proto = eth->h_proto;

    if (h_proto == htons(ETH_P_IP))
    {
        struct iphdr *iph = data + nh_off;
        struct udphdr *udph = data + nh_off + sizeof(struct iphdr);
        if (udph + 1 > (struct udphdr *)data_end)
        {
            return XDP_DROP;
        }
        if (iph->frag_off & IP_FRAGMENTED)
        {
            return XDP_DROP;
        }
        if (iph->protocol == IPPROTO_UDP && udph->dest != htons(2302))
        {
            return XDP_DROP;
        }
        if (iph->protocol == IPPROTO_UDP && udph->source == htons(53))
        {
            return XDP_DROP;
        }
        if (iph->protocol == IPPROTO_TCP && udph->dest != htons(22))
        {
            return XDP_DROP;
        }
        if (iph->protocol == IPPROTO_ICMP)
        {
            return XDP_DROP;
        }

    }
/*    if (h_proto == htons(ETH_P_IPV6))*/
/*   {*/
/*       return XDP_DROP;*/
/*   }*/

    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
