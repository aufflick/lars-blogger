<if @blog.title@ not nil>
  <h4>@blog.title@</h4>
</if>
<p>
  @blog.content@
  <br>
  <table cellpadding="0" cellspacing="0" border="0" width="100%">
    <if @show_poster_p@ true>
      <tr>
        <td>
          <font size="-2" color="#999999">
            <br>
            Posted by @blog.poster_first_names@ @blog.poster_last_name@ at @blog.posted_time_pretty@
            <if @admin_p@ eq 1>
              &nbsp;&nbsp;&nbsp;&nbsp;
              <a href="@blog.edit_url@">Edit</a> - 
              <if @blog.draft_p@ true>
                <a href="@blog.publish_url@">Publish</a>
              </if>
              <else>
                <a href="@blog.revoke_url@">Draft</a>
              </else>
            </if>
          </font>
        </td>
      </tr>
    </if>
    <tr>
      <td align="right">
        <a href="@blog.entry_archive_url@" title="Permanent URL for this entry">#</a> -
        <a href="@blog.google_url@" title="Search for @blog.title@ on Google">G</a> -
        <if @comments_html@ nil>
          <if @blog.comments_view_url@ not nil>
            <if @blog.num_comments@ gt 0>
              <a href="@blog.comments_view_url@" title="View comments on this entry">@blog.num_comments@ <if @blog.num_comments@ eq 1>comment</if><else>comments</else></a> -
            </if>
          </if>
        </if>
        <a href="@blog.comment_add_url@" title="Comment on this entry">Add comment</a>
      </td>
    </tr>
  </table>
</p>

<if @comments_html@ not nil>
  <table align=center width="50%"><tr><td><hr></td></tr></table>
  <h4>Comments</h4>
  <blockquote>
   @comments_html@
  </blockquote>
  <center><a href="@blog.comment_add_url@" title="Comment on this entry">Add comment</a></center>
</if>
