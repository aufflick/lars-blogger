<master>
<property name="title">@page_title@</property>
<property name="focus">entry.title</property>   
<property name="context">@context@</property>   

<script type="text/javascript">
    function setEntryDateToToday() {
        document.forms['entry'].entry_date.value = '@now_ansi@';
    }
</script>

<formtemplate id="entry"></formtemplate>

