<!--
Copyright: Gianluca Costa & Andrea de Franceschi 2007-2010, http://www.xplico.org
 Version: MPL 1.1/GPL 2.0/LGPL 2.1
-->
<script type="text/javascript">
  swfobject.embedSWF("/files/open-flash-chart.swf", "my_chart", "750", "340", "9.0.0",
      "",
      {"data-file":"/dns_messages/gdata"}
);
</script>
<script type="text/javascript">
  function go_gpage(id) { //funzione con il link alla pagina che si desidera raggiungere
    window.location.href = '<?php echo $dns_gpage_url?>';
  }
</script>
<div class="generic">   </div>

<div class="graph">
  <div id="my_chart"></div> 
</div>

<!--   <div class="graph_select"> -->
<div class="search" >
  <center>
  <?php echo $form->create('formtime' ,array( 'url' => array('controller' => 'dns_messages', 'action' => 'graph')));
        echo $form->radio('timeinterval', $time_list , array('separator' => ' ', 'legend' => false ));
        echo '<br /><br />';
        echo $form->end(__('Change', true)); ?>
  </center>
</div>

