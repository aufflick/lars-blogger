<master>
<property name="title">@page_title@</property>
<if @rss_file_url@ not nil>
  <property name="header_stuff">
    <link rel="alternate" type="application/rss+xml" title="RSS" target=_test href="@rss_file_url@" />
  </property>
</if>
<include src="admin-links">

<table width="100%">
  <tr>
    <td valign="top">
      <include src="blog">
    </td>
    <td valign="top">

      <table width="100%" cellspacing="0" cellpadding="2">
        <tr>
          <th bgcolor="#e0d0b0">
            Archive
          </th>
        </tr>
        <tr>
          <td nowrap>
            <include src="blog-months">
          </td>
        </tr>
        <tr>
          <td height="16">
            <table><tr><td></td></tr></table>
          </td>
        </tr>
        <if @rss_file_url@ not nil>
          <tr>
            <th bgcolor="#e0d0b0" nowrap>
              Syndication Feed
            </th>
          </tr>
          <tr>
            <td nowrap>
              <a href="@rss_file_url@">RSS 1.0/RDF/XML</a>
            </td>
          </tr>
        </if>
      </table>

    </td>
  </tr>
</table>

