# Expects:
# blog:onerow
# show_comments_p:onevalue,optional
# retrun_url:onevalue,optional
# package_id:optional
# screen_name:onevalue,optional
# max_content_length:integer,optional

if { ![exists_and_not_null show_comments_p] } {
    set show_comments_p "f"
}

# Maybe package_id is supplied, but maybe not
if { ![info exists package_id] } {
    set package_id [ad_conn package_id]
}

if { ![exists_and_not_null return_url] } {
    set return_url "[ad_conn url]?[ad_conn query]"
}
if { ![exists_and_not_null screen_name] } {
    set screen_name ""
}

if { ![exists_and_not_null max_content_length] } {
    set max_content_length 0
}        

set package_url [lars_blog_public_package_url -package_id $package_id]

set user_id [ad_conn user_id]

set general_comments_package_url [general_comments_package_url]

set show_poster_p [ad_parameter "ShowPosterP" "" "1"]

set entry_id $blog(entry_id)

if { [empty_string_p $screen_name] } {
    set blog(entry_archive_url) "${package_url}one-entry?[export_vars { entry_id }]"
} else {
    set blog(entry_archive_url) "${package_url}user/$screen_name/one-entry?[export_vars { entry_id }]"
}

set blog(edit_url) "${package_url}entry-edit?[export_vars { entry_id return_url }]"
set blog(delete_url) "${package_url}entry-delete?[export_vars { entry_id return_url }]"

set blog(publish_url) "${package_url}entry-publish?[export_vars { entry_id return_url }]"
set blog(revoke_url) "${package_url}entry-revoke?[export_vars { entry_id return_url }]"

set blog(write_p) [permission::write_permission_p -object_id $blog(entry_id) -creation_user $blog(user_id)]

set blog(google_url) "http://www.google.com/search?[export_vars { {q $blog(title) } }]"

if { ![empty_string_p $general_comments_package_url] } {
    set blog(comment_add_url) "${general_comments_package_url}comment-add?[export_vars { { object_id $entry_id } { object_name $blog(title) } { return_url "${package_url}flush-cache?[export_vars { return_url }]"} }]"
}

set blog(comments_view_url) "${package_url}one-entry?[export_vars { entry_id }]"

set blog(posted_time_pretty) [util::age_pretty \
                                  -timestamp_ansi $blog(entry_date_ansi) \
                                  -sysdate_ansi $blog(sysdate_ansi)]

set display_categories [lars_blog_categories_p -package_id [ad_conn package_id]]

if { [string equal $show_comments_p "t"] } {
    lars_blogger::entry::get_comments -entry_id $entry_id
}

set blog(content) [ns_adp_parse \
                       -string [ad_html_text_convert \
                                    -from $blog(content_format) \
                                    -to "text/html" \
                                    -- $blog(content)]]

if { $max_content_length > 0 && [string length $blog(content)] > $max_content_length  } {
    set blog(content) [util_close_html_tags $blog(content) $max_content_length $max_content_length]
    append blog(content) "..."
    if { ![string equal [ad_return_url] $blog(entry_archive_url)] } {
        append blog(content) "<br><a href=\"$blog(entry_archive_url)\">(more)</a>"
    }
}


