<!--
Copyright: Gianluca Costa & Andrea de Franceschi 2007-2010, http://www.xplico.org
 Version: MPL 1.1/GPL 2.0/LGPL 2.1
-->
<div class="generic">
<h6><?php __('URL:'); ?> <b><?php echo 'http://'.htmlentities($message['Web']['url']); ?></b></h6>
<!--<h6>File:&nbsp; <?php echo $message['Web']['rs_body']; ?> </h6>-->
<div id="messageframe">
<table id="messagelist" summary="Message list" cellspacing="0">
<tr>
	<th><?php __('HTTP Request'); ?></th>
        <th><?php __('HTTP Responce'); ?></th>
</tr>

<tr>
        <td><b>ip:port => <?php echo $src_ip_port ?></b> </td>
        <td><b>ip:port => <?php echo $dst_ip_port ?></b> </td>
</tr>

<tr>
        <td><?php __('Header: Click to'); ?> <span style="cursor: pointer;text-decoration: underline" onclick="makeRequest('<?php echo '/webs/reqHeader/'.$message['Web']['id']; ?>')"> <b><?php __('View'); ?></b></span> <?php __('or'); ?> <?php echo $html->link(__('Download', true), 'reqHeader/' . $message['Web']['id']); ?> </td>
        <td><?php __('Header: Click to'); ?> <span style="cursor: pointer;text-decoration: underline" onclick="makeRequest('<?php echo '/webs/resHeader/'.$message['Web']['id']; ?>')"> <b><?php __('View'); ?></b></span> <?php __('or'); ?> <?php echo $html->link(__('Download', true), 'resHeader/' . $message['Web']['id']); ?> </td>
</tr>

<tr>
        <?php if ($message['Web']['rq_bd_size'] == 0) : ?>
            <td><?php __('Body: None'); ?> </td>
        <?php else : ?>
            <td><?php __('Body: Click to'); ?> <span style="cursor: pointer;text-decoration: underline" onclick="makeRequest('<?php echo '/webs/reqBody/'.$message['Web']['id']; ?>')"> <b><?php __('View'); ?></b></span> <?php __('or'); ?> <?php echo $html->link(__('Download', true), 'reqBody/' . $message['Web']['id']) ?> </td>
        <?php endif ?>
        <?php if ($message['Web']['rs_bd_size'] == 0) : ?>
            <td><?php __('Body: None'); ?> </td>
        <?php else : ?>
            <td><?php __('Body: Click to'); ?> <span style="cursor: pointer;text-decoration: underline" onclick="makeRequest('<?php echo '/webs/resBody/'.$message['Web']['id']; ?>')"> <b><?php __('View'); ?></b></span> <?php __('or'); ?> <?php echo $html->link(__('Download', true), 'resBody/' . $message['Web']['id']).'  (sz:'.$message['Web']['rs_bd_size'].'b) content type:'.$message['Web']['content_type']?> </td>
        <?php endif ?>
</tr>
</table>
<div class="generic centered">
<div id="displ" > </div>
<textarea  id="contenuto" readonly="readonly" style="text-align: left" rows="11" cols="80"></textarea>
</div>
</div>
</div>