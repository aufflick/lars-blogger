<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="entries">
        <querytext>
		    select entry_id,
		           to_char(entry_date, 'YYYY-MM-DD') as entry_date_pretty, 
		           title,
		           content
		    from   pinds_blog_entries
		    where  package_id = :package_id
		    and    posted_date > current_timestamp - interval '14 days'
		    and    draft_p = 'f'
                    and    deleted_p = 'f'
		    order  by entry_date desc, posted_date desc
        </querytext>
    </fullquery>

</queryset>
