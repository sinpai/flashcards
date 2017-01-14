if(('#asubmit-button').length > 0){
    var start = 0;
    start = new Date();
};
$("#asubmit-button").on('click', function() {
    var cur = new Date();
    alert(cur-start);
    document.getElementById('answertime').value = cur - start;
});
