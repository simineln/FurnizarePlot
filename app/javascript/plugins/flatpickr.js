import flatpickr from 'flatpickr'
require('flatpickr/dist/flatpickr.css')

document.addEventListener("turbolinks:load", () => {
  flatpickr("[class='flatpickr']", {
    altInput: true,
    mode: 'range',
    altFormat: "F j, Y",
    dateFormat: "Y-m-d",
  })
})

// document.addEventListener("turbolinks:load", () => {
//   flatpickr("[data-behavior='flatpickr']", {
//     altInput: true,
//     altFormat: "F j, Y",
//     dateFormat: "Y-m-d",
//   })
// })


// flatpickr(".datepicker", {

// })