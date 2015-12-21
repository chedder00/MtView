$(document).ready ->

  $("[data-mask]").each (index, value) ->
    element = undefined
    element = undefined
    element = $(value)
    element.mask $(value).data("mask")