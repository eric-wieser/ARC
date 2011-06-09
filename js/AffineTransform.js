var AffineTransform = function(v, m) {
	this.matrix = m;
	this.translation = v;
}

AffineTrasnform.prototype = {
	toWorldSpace = function(objectVector) {
		return this.matrix.times(objectVector).plus(this.translation);
	},
	toObjectSpace = function(worldVector) {
		return this.matrix.inverse().times(worldVector.minus(this.translation));
	},
	inverse = function() {
		var inv = this.matrix.inverse();
		return new AffineTrasnform(inv.times(this.translation.minus()), inv);
	},
	combine = function(that) {
		return new AffineTrasnform(this.toWorldSpace(that.translation), this.matrix.times(that.matrix);
	},
	toSVGTransformString() {
		var m = this.matrix, v = this.translation;
		return 'M'+m.a + ' ' + m.c + ' ' + m.b + ' ' + m.d + ' ' + v.x + ' ' + v.y
	}
}

AffineTranform.identity = new AffineTransform(Vector.zero, Matrix.identity);