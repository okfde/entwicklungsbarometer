(function() {
  this.magnitude = function(n) {
    var order;
    order = Math.floor(Math.log(n) / Math.LN10);
    return Math.pow(10, order);
  };

}).call(this);
