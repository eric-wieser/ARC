function ReferenceAffineTransform(first, rest) {
	this.first = first
	this.rest = rest || new AffineTransform();
}

ReferenceAffineTransform.prototype = {
	clone: function() {
		return new AffineTransform(this.first, this.rest);
	},
	evaluate: function() {
		return this.rest.evaluate().combine(this.first.evaluate())
	}
	toWorldSpace: function(objectVector) {
		return this.rest.toWorldSpace(this.first.toWorldSpace(objectVector));
	},
	toObjectSpace: function(worldVector) {
		return this.first.toObjectSpace(this.rest.toObjectSpace(worldVector));
	},
	vectorToWorldSpace: function(objectVector) {
		return this.rest.vectorToWorldSpace(this.first.vectorToWorldSpace(objectVector));
	},
	vectorToObjectSpace: function(worldVector) {
		return this.first.vectorToObjectSpace(this.rest.vectorToObjectSpace(worldVector));
	},
	inverse: function() {
		return new ReferenceAffineTransform(this.rest.inverse(), this.first.inverse());
	},
	combine: function(that) {
		return new ReferenceAffineTransform(that, this);
	},
	toSVGTransformString: function() {
		return this.evaluate().toSVGTransformString()
	},
};