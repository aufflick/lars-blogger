ad_library {
     Procs used by the blogger module.
     @author Lars Pind (lars@pinds.com)
     @creation-date 2002
     @cvs-id $Id$
}

ad_proc -deprecated -warn lars_blog_entry_add {
    {-entry_id:required}
    {-package_id:required}
    {-title:required}
    {-title_url ""}
    {-category_id ""}
    {-content:required}
    {-content_format:required}
    {-entry_date:required}
    {-draft_p:required}
} {
    Add the blog entry and then flush the cache so that the new entry shows up.
} {
    return [lars_blogger::entry::new \
                -entry_id $entry_id \
                -package_id $package_id \
                -title $title \
                -title_url $title_url \
                -category_id $category_id \
                -content $content \
                -content_format $content_format \
                -entry_date $entry_date \
                -draft_p $draft_p]
}

ad_proc lars_blog_setup_feed {
    -user:boolean
    {-package_id ""}
} {
    if { [empty_string_p $package_id] } {
        set package_id [ad_conn package_id]
    }
    
    set timeout [expr 30*60]
    set channel_title [lars_blog_name]
    set creation_user [ad_conn user_id]
    set creation_ip [ns_conn peeraddr]
    
    # Package feed
    if { [parameter::get -parameter "package_rss_feed_p" -package_id $package_id -default 1] } {
        
        # check whether there's been a channel setup for this instance
        set summary_context_id [db_string select_instance_channel {} -default {}]
            
        if { [empty_string_p $summary_context_id] } {
            # Setup a channel for this instance
            set summary_context_id [db_exec_plsql create_instance_channel {}]
        }
        
        # check whether there's been a feed setup for this instance
        set exists_instance_feed_p [db_string exists_instance_feed_p {}]
        
        if { [string equal $exists_instance_feed_p "0"] } {
            # Setup an RSS feed for this instance
            set channel_link [lars_blog_public_package_url]
            
            set subscr_id [db_exec_plsql create_subscr {}]
            db_dml update_subscr {}
            
            # Run it now
            rss_gen_report $subscr_id
        }
    }

    if { [parameter::get -parameter "user_rss_feed_p" -package_id $package_id -default 0] } {

        # check whether there's been a channel setup for this instance
        set summary_context_id [db_string select_user_channel {} -default {}]

        if { [empty_string_p $summary_context_id] } {
            # Setup a channel for this instance
    	set summary_context_id [db_exec_plsql create_user_channel {}]
        }

        # check whether there's been a feed setup for this user
        set exists_user_feed_p [db_string exists_user_feed_p {}]

        if { !$exists_user_feed_p } {
            set screen_name [acs_user::get_element -user_id $creation_user -element screen_name]
            
            if { ![empty_string_p $screen_name] } {
                # Setup an RSS feed for the user
                set channel_link "[lars_blog_public_package_url]user/$screen_name/"
                
                set subscr_id [db_exec_plsql create_subscr {}]
                db_dml update_subscr {}
                
                # Run it now
                rss_gen_report $subscr_id
            } else {
                ns_log Warning "lars-blogger: User $creation_user has no screen_name, cannot setup an RSS feed for user"
            }
        }
    }
}

ad_proc -private lars_blog_get_as_string_mem { 
    package_id
    admin_p
} {
    return [template::adp_parse "[acs_package_root_dir "lars-blogger"]/www/blog" [list package_id $package_id]]
}

    
ad_proc -public lars_blog_get_as_string { 
    -package_id
    -url
} {
    if { ![exists_and_not_null package_id] } {
        array set blog_site_node [site_node $url]
        set package_id $blog_site_node(object_id)
    }
    set admin_p [ad_permission_p $package_id admin]
    return [util_memoize "lars_blog_get_as_string_mem $package_id $admin_p" 600]
}

ad_proc lars_blog_flush_cache {
    {package_id ""}
} {
    if { [empty_string_p $package_id] } {
        set package_id [ad_conn package_id]
    }
    # Flush both admin and non-admin version
    util_memoize_flush "lars_blog_get_as_string_mem $package_id 0"
    util_memoize_flush "lars_blog_get_as_string_mem $package_id 1"
}

ad_proc -public lars_blog_public_package_url {
    -package_id
} {
    if { ![exists_and_not_null package_id] } {
        # No package_id given, so we'll just use ad_conn
        set package_id [ad_conn package_id]
        set default_url [ad_conn package_url]
    } else {
        if { [catch { 
            # This will fail if the package has been mounted on more than one URL ... hm.
            set default_url [apm_package_url_from_id $package_id]
        }] } { 
            # In that case, we'll just hope that they set up the parameter
            set default_url ""
        }
    }
    return [ad_parameter -package_id $package_id "public_url" "lars-blogger" $default_url] 
}

ad_proc -public lars_blog_name { 
    -package_id
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }
    array set site_node [site_node::get_from_object_id -object_id $package_id]
    return $site_node(instance_name)
}

ad_proc -public lars_blog_header_background_color {
    -package_id
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }
    return [ad_parameter -package_id $package_id "HeaderBackgroundColor" "lars-blogger" "#dcdcdc"] 
}

ad_proc -public lars_blog_categories_p {
    -package_id
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }
    return [ad_parameter -package_id $package_id "EnableCategoriesP" "lars-blogger" "1"]
}

ad_proc -public lars_blog_stylesheet_url {
    -package_id
} {
    if { ![exists_and_not_null package_id] } {
        set package_id [ad_conn package_id]
    }
    return [parameter::get -package_id $package_id -parameter "StylesheetURL" -default "/resources/lars-blogger/lars-blogger.css"] 
}
