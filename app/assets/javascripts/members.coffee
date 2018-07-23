$(document).on 'turbolinks:load', ->
  $('#member_email, #member_name').keypress (e) ->
    if e.which == 13 && valid_email($( "#member_email" ).val()) && $( "#member_name" ).val() != ""
      $('.new_member').submit()

  $('#member_email, #member_name').bind 'blur', ->
    if valid_email($( "#member_email" ).val()) && $( "#member_name" ).val() != ""
      $('.new_member').submit()

  $('body').on 'click', 'a.remove_member', (e) ->
    $.ajax '/members/'+ e.currentTarget.id,
        type: 'DELETE'
        dataType: 'json',
        data: {}
        success: (data, text, jqXHR) ->
          Materialize.toast('Membro removido', 4000, 'green')
          $('#member_' + e.currentTarget.id).remove()
        error: (jqXHR, textStatus, errorThrown) ->
          Materialize.toast('Problema na remoção de membro', 4000, 'red')
    return false

  $('.new_member').on 'submit', (e) ->
    $.ajax e.target.action,
        type: 'POST'
        dataType: 'json',
        data: $(".new_member").serialize()
        success: (data, text, jqXHR) ->
          insert_member(data['id'], data['name'],  data['email'])

          $('#member_name, #member_email').val("")
          $('#member_name').focus()

          $('.update_member input').bind 'blur', (e) ->
            update_member(e.currentTarget.id)
            return

          Materialize.toast('Membro adicionado', 4000, 'green')
        error: (jqXHR, textStatus, errorThrown) ->
          Materialize.toast('Problema na hora de incluir membro', 4000, 'red')
    return false

  $('.update_member input').bind 'blur', (e) ->
    update_member(e.currentTarget.id)

  update_member = (id) ->
    member_id = id.split('_')[2]
    if !member_id
      return false

    member_name = $('#member_name_' + member_id).val()
    json = {
      member: {
        name: member_name,
        email: $('#member_email_' + member_id).val(),
        campaign_id: $('#campaign_id').val()
      }
    }

    $.ajax '/members/' + member_id,
        type: 'PUT'
        dataType: 'json',
        data: json,
        success: (data, text, jqXHR) ->
          Materialize.toast('Membro ' + member_name + ' atualizado com sucesso!', 4000, 'green')
        error: (jqXHR, textStatus, errorThrown) ->
          Materialize.toast('Problema na atualização do membro ' + member_name, 4000, 'red')
    return false
  return

valid_email = (email) ->
  /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/.test(email)

insert_member = (id, name, email) ->
  insert_template = """
      <div class="member update_member" id="member_#{id}">
        <div class="row">
          <div class="col s12 m5 input-field">
            <input id="member_name_#{id}" type="text" class="validate" value="#{name}">
            <label for="member_name_#{id}" class="active">Nome</label>
          </div>
          <div class="col s12 m5 input-field">
            <input id="member_email_#{id}" type="email" class="validate" value="#{email}">
            <label for="member_email_#{id}" class="active" data-error="Formato incorreto">Email</label>
          </div>
          <div class="col s3 offset-s3 m1 input-field">
            <i class="material-icons icon">visibility</i>
          </div>
          <div class="col s3 m1 input-field">
            <a href="#" class="remove_member" id="#{id}">
              <i class="material-icons icon">delete</i>
            </a>
          </div>
        </div>
      </div>
  """
  $('.member_list').append(insert_template)
  return
