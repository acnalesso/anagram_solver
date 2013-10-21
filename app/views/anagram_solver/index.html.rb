<% form_tag(:new_anagram, multipart: true) do |f| %>
  <%= f.file_field_tag :dictionary %>
<% end %>

<div id="search_area">
  <% form_tag(:search) do |f| %>
    <%= f.text_field_tag :word %>
    <%= f.submit_tag :search %>
  <% end %>
</div>

<div id="results">
  <span>You've searched for:</span>
</div>
