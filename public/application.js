// Add ajax for the
// player hit,
// player stay,
// and dealer hit actions.

// player hit

$(document).ready(function(){
  player_hits();
  player_stays();
  dealer_hits();
});

function player_hits(){
  $(document).on('click', 'form#hit_form input', function(){
    $.ajax({
      type: 'POST',
      url: '/game/player/hit'
      //data:
    }).done(function(msg){
      $('#game').replaceWith(msg);
    });

    return false;
  });
}

function player_stays(){
  $(document).on('click', 'form#stay_form input', function(){
    $.ajax({
      type: 'POST',
      url: '/game/player/stay'
      //data:
    }).done(function(msg){
      $('#game').replaceWith(msg);
    });

    return false;
  });
}

function dealer_hits(){
  $(document).on('click', 'form#dealer_hit input', function(){
    $.ajax({
      type: 'POST',
      url: '/game/dealer/hit'
      //data:
    }).done(function(msg){
      $('#game').replaceWith(msg);
    });

    return false;
  });
}

//ajax explained: https://www.gotealeaf.com/lessons/baf2d715/assignments/1915
//step 1

// $(document).ready(function(){

//   $('#hit_form input').click(function(){
//     $.ajax({
//       type: 'POST',
//       url: '/game/player/hit'
//       //data:
//     }).done(function(msg){
//       //msg is the payload
//       alert(msg);
//     });

//     return false;
//   });


// });

// &&   erb :game, layout: false at main.rb

//step 2
// $(document).ready(function(){

//   $('#hit_form input').click(function(){
//     $.ajax({
//       type: 'POST',
//       url: '/game/player/hit'
//       //data:
//     }).done(function(msg){
//       $('#game').html(msg);
//     });

//     return false;
//   });


// });

//step 3 - resolve dup game id's

// $(document).ready(function(){

//   $('#hit_form input').click(function(){
//     $.ajax({
//       type: 'POST',
//       url: '/game/player/hit'
//       //data:
//     }).done(function(msg){
//       $('#game').replaceWith(msg);
//     });

//     return false;
//   });


// });

//step 4 - resolve hit twice no layout issue
// $(document).ready(function(){
// // on function, click first param, second is the selector, 3rd is anoyomous
//   $(document).on('click', '#hit_form input', function(){
//     $.ajax({
//       type: 'POST',
//       url: '/game/player/hit'
//       //data:
//     }).done(function(msg){
//       $('#game').replaceWith(msg);
//     });

//     return false;
//   });

// });

//this syntax binds this event to the click listener continuously. A little more
// performance intensive, but not that big of a deal on this use case.
// additional pay loads maybe you should use angular instead.



