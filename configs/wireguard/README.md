# wgluks -- WireGuard endpoint for salo-pc remote LUKS unlock

Host-level `wg-quick@wgluks` (not a container). The desktop's initrd dials this
endpoint on boot so the encrypted disk can be unlocked over SSH from away. The
LUKS passphrase is still the gate; this only grants boot-time reachability.

## Topology
- VPS `wgluks` 10.200.0.1/24, UDP 51820 (must be open to the internet).
- Peers (public keys live in the template, safe to commit):
  - 10.200.0.2  salo-pc initrd
  - 10.200.0.3  phone (remote unlock)
  - 10.200.0.4  laptop (remote unlock)
- One scoped rule allows the peers to reach each other:
  `iptables -A FORWARD -i wgluks -o wgluks -j ACCEPT` (added by PostUp).

## What is tracked vs secret
- Tracked: `wgluks.conf.template` (key redacted), `install-wgluks.sh`, this file.
- Secret (gitignored, in `data/wireguard/wgluks.conf`): the full config incl. the
  server PrivateKey. Back this up separately (password manager / encrypted backup).

## Rebuild on a wiped VPS
1. Restore `data/wireguard/wgluks.conf` from backup (or recreate from the template
   and a fresh `wg genkey` -- a new server key means updating every peer's config).
2. `./configs/wireguard/install-wgluks.sh`
3. Confirm UDP 51820 is open at the provider firewall.

## Peer configs (the other ends)
- Desktop initrd: declarative in dotfiles `hosts/desktop/remote-unlock.nix`; its
  private key is `/persist/secrets/wgluks-initrd.key` on salo-pc.
- Laptop: `~/wgluks-unlock.conf`. Phone: WireGuard app profile.
