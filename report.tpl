<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>ILM Report</title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />

  <style>
    <%- include('report.css') %>
  </style>  

</head>
<body>

<div class="summary">
    <span><b>Cluster:</b> <%= cluster.cluster_name %></span>
    <span><b>Nodes:</b> <%= nodes.length %></span>
    <span><b>Primary shards:</b> <%= primary_shards_count %></span>
</div>

<% for(const node of nodes) { %>
<div class="node <%= node.roles.join(' ')%>">

    <div class="inline-container">
        <span class="node-name"><%= node.name %> (<%= node.shards.length %>)</span>
        
        <% node.roles.forEach(role => { %>
            <span class="node-role"><%= role %></span>
        <% }) %>
    </div>

    <div class="inline-container">
        <ul class="shards">
        <% node.shards.forEach(s => { %>
            <li 
                class="shard <%= s.tier ? s.tier.join(' ') : '' %>"        
                data-text="[<%= s.prirep %>] [<%= s.tier %>] (<%= s.docs %>) <%= s.index %>"
                >
                <%= s.prirep.toUpperCase() %>
            </li>
        <% }) %>    
        </ul>
    </div>
</div>
<% } %>

<div class="node">
 <div class="inline-container">
        <span class="node-name">Unassigned</span>        
    </div>

    <div class="inline-container">
        <ul class="shards">
        <% unassigned_shards.forEach(s => { %>
            <li 
                class="shard <%= s.tier ? s.tier.join(' ') : '' %>"        
                data-text="[<%= s.prirep %>] [<%= s.tier %>] (<%= s.docs %>) <%= s.index %>"
                >
                <%= s.prirep.toUpperCase() %>
            </li>
        <% }) %>    
        </ul>
    </div>
</div>


<div class="legend">
    <p>Legend<p>

    <span class="legend-item"> Unknown </span>
    <span class="legend-item data_cold"> data_cold </span>
    <span class="legend-item data_warm"> data_warm </span>
    <span class="legend-item data_hot"> data_hot </span>
    <span class="legend-item data_content"> data_content </span>
    <p><span class="legend-item">P</span> Primary shard</p>
    <p><span class="legend-item">R</span> Replica</p>
</div>

</body>
</html>
