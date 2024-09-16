<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>ILM Report</title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <link href="report.css" rel="stylesheet" />

</head>
<body>

<% for(const node of nodes) { %>
<div class="node <%= node.roles.join(' ')%>">
    <span class="node-name"><%= node.name %></span>
    <span class="node-roles"><%= node.roles.join(' ') %></span>
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
<% } %>



<p>Legend<p>

<span class="shard"> Inconnu </span>
<span class="shard data_cold"> data_cold </span>
<span class="shard data_warm"> data_warm </span>
<span class="shard data_hot"> data_hot </span>
<span class="shard data_content"> data_content </span>
<p><span class="shard">P</span> primary</p>
<p><span class="shard">R</span> replica</p>

</body>
</html>