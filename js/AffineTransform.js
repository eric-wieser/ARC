function AffineTransform(v, m) {
	if(v instanceof Matrix)
		m = v, v = null;
	this.matrix = m || Matrix.identity;
	this.translation = v || Vector.zero;
}

AffineTransform.prototype = {
	toWorldSpace: function(objectVector) {
		return this.matrix.times(objectVector).plus(this.translation);
	},
	toObjectSpace: function(worldVector) {
		return this.matrix.inverse().times(worldVector.minus(this.translation));
	},
	inverse: function() {
		var inv = this.matrix.inverse();
		return new AffineTransform(inv.times(this.translation.minus()), inv);
	},
	combine: function(that) {
		return new AffineTransform(this.toWorldSpace(that.translation), this.matrix.times(that.matrix));
	},
	toSVGTransformString: function() {
		var m = this.matrix, v = this.translation;
		return 'M'+m.a + ' ' + m.c + ' ' + m.b + ' ' + m.d + ' ' + v.x + ' ' + v.y
	}
}

AffineTransform.identity = new AffineTransform();