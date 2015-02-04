<!--
Copyright: Gianluca Costa & Andrea de Franceschi 2007-2010, http://www.xplico.org
 Version: MPL 1.1/GPL 2.0/LGPL 2.1
-->
<div class="pols">
<h2><?php __('Cases List'); ?></h2>

<table cellpadding="0" cellspacing="0">
<tr>
	<th><?php __('Name'); ?></th>
	<th><?php __('External Reference'); ?></th>
        <th><?php __('Type'); ?></th>
	<th><?php __('Actions'); ?></th>
</tr>
<?php $i = 0; ?>
<?php foreach ($pols as $pol): ?>
<tr>
	<td><?php echo $html->link($pol['Pol']['name'], '/pols/view/'.$pol['Pol']['id']); ?></td>
	<td><?php echo $pol['Pol']['external_ref']; ?></td>
        <?php if ($pol['Pol']['realtime']) : ?>
        <td><?php __('Live'); ?></td>
        <?php else : ?>
        <td><?php __('Files'); ?></td>
        <?php endif ?>
	<td class="actions">
		<?php 
                      echo $html->link(__('Delete', true),'/pols/delete/' . $pol['Pol']['id'], null, 'Are you sure you want to delete \'' . $pol['Pol']['name'] . '\'');
                ?>
	</td>
</tr>
<?php endforeach; ?>
</table>
</div>
