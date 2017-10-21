merge into mls_photos p
using (select m.mls_id, m.mls_number, mp.photo_seq
       from mls_listings m
       ,    mls_photos mp
       where m.source_id = 8
       and m.mls_id = mp.mls_id) p2
on (p.mls_id = p2.mls_id and
    p.photo_seq = p2.photo_seq)
when matched then
  update set photo_url = 'http://visulate.com/images/mls/8/'||p2.mls_number||'-'||p2.photo_seq||'.jpg';