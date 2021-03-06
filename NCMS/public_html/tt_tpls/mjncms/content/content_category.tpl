[% USE loc -%]
[% IF TT_VARS.category_id %][% TT_VARS.category_slug='' %][% END -%]
[% IF !TT_VARS.category_id && !TT_VARS.category_slug %]
	[% loc('Category slug/id is not defined') | hmtl %][% RETURN -%]
[% END -%]
[%
	cats_res = TT_CALLS.content_get_catrecord(
		[], {
		cat_id => TT_VARS.category_id, 
		slug => TT_VARS.category_slug, 
		
	})
%][% cat=cats_res.records.values.shift -%]
[% UNLESS cat.cat_id %][% loc('Could not found requested cat') | html %][% RETURN %][% END -%]
[% slug_base='' -%]
[% IF cat.level>1 %]
	[% parents=TT_CALLS.content_get_catparent_tree(cat.cat_id) -%]
	[% 
		cats_res = TT_CALLS.content_get_catrecord([parents])
	%]
	[% FOREACH cid=parents %][% slug_base=slug_base _ '/' _ cats_res.records.${cid}.cname %][% END -%]
[% ELSE %]
	[% slug_base=slug_base _ '/' _ cat.cname -%]
[% END %]
[%
	pages_res = TT_CALLS.content_get_pagerecord({
		cat_id => cat.cat_id,
		
	})
%]
<h2>[% cat.name | html %]</h2>

[% UNLESS pages_res.pages_res.size -%]
	[% loc('No pages found in current category') | html -%]
[% ELSE #UNLESS pages_res.pages_res.size -%]
	[% FOREACH page=pages_res.pages_res -%]
		<h3>[% page.header | html %]</h3>
		[% page.intro %]<br />
		[% IF page.body %]<a href="[% slug_base %]/[% page.slug | html %][% SESSION.EXTENSIONS_PAGE %]">[% loc('Read more') %]...</a><br />[% END -%]
		<i>[% page.dt_publishstart_fmt | html %], [% page.author | html %]</i>
		<hr class="w80" />
	[% END #FOREACH page=pages_res.pages_res -%]
[% END #UNLESS pages_res.pages_res.size -%]

