function Vector(x, y) {
	this.x = x;
	this.y = y;
}
Vector.prototype = {
	magnitude: function() {
		return Math.sqrt(this.dot(this));
	},
	unit: function() {
		return this.scale(1 / this.magnitude());
	},
	plus: function(that) {
		return new Vector(this.x + that.x, this.y + that.y);
	},
	minus: function(that) {
		if(!that)
			return new Vector(-this.x, -this.y);
		else
			return new Vector(this.x - that.x, this.y - that.y);
	},
	times: function(factor) {
		return new Vector(this.x * factor, this.y * factor);
	},
	over: function(factor) {
		return new Vector(this.x / factor, this.y / factor);
	},
	dot: function(that) {
		return this.x * that.x + this.y * that.y;
	},
	distanceTo: function(that) {
		return this.subtract(that).magnitude();
	},
	lerp = function(that, t) {
		return that.times(t).plus(this.times(1-t));
	},
	toString: function() {
		return '(' + this.x + ',' + this.y + ')';
	},
	clone: function() {
		return new Vector(x, y);
	}
}