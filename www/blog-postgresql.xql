<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

	<partialquery name="date_clause_archive">
		<querytext>
			date_trunc(:archive_interval, entry_date) = :archive_date
		</querytext>
	</partialquery>

	<partialquery name="date_clause_default">
		<querytext>
			entry_date > current_timestamp - interval '30 days'
		</querytext>
	</partialquery>

    <fullquery name="blog">
        <querytext>
		    select entry_id,
		           to_char(entry_date, 'fmDayfm, Month fmDDfm, YYYY') as entry_date_pretty, 
		           to_char(entry_date, 'YYYY/MM/DD/') as entry_archive_url,
		           to_char(entry_date, 'YYYY-MM-DD') as entry_date,
		           title,
		           content,
		           draft_p,
		           p.first_names as poster_first_names,
		           p.last_name as poster_last_name,
		           to_char(posted_date , 'HH24:MI') as posted_time_pretty,
		           (select count(gc.comment_id) 
		            from general_comments gc, cr_revisions cr 
		            where gc.object_id = entry_id
		            and   content_item__get_live_revision(gc.comment_id) = cr.revision_id) as num_comments
		    from   pinds_blog_entries e join 
		           acs_objects o on (o.object_id = e.entry_id) join 
		           persons p on (p.person_id = o.creation_user)
		    where  package_id = :package_id
		    and    $date_clause
		    and    draft_p = 'f'
		    and    deleted_p = 'f'
		    order  by entry_date desc, posted_date desc
        </querytext>
    </fullquery>

</queryset>
