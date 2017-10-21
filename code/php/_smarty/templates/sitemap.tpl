<?xml version="1.0" encoding="UTF-8"?>
<{$listings.DOC_TYPE} xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
{foreach name=outer item=item from=$listings.LOC key=k}
  <{$listings.ENTRY_TYPE}>
    <loc>{$listings.BASE_URL}{$item}</loc>
  </{$listings.ENTRY_TYPE}>
{/foreach}
</{$listings.DOC_TYPE}>