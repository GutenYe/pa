class Array
 
=begin
	# extend options are symbols and hash, symbol as a boolean option.
	#
	#   :a #=> { a: true }
	#   :_a #=> { a: false}
	#
	# @example
	#   def foo(*args)
	#     paths, o = args.extract_extend_options
	#   end
	#
	#   foo(1, :a, :_b, :c => 2) 
	#     #=> paths is [1]
	#     #=> o is {a: true, b: false, c: 2}
	#
	# @param [Symbol, Hash] *defaults
	# @return [Array<Object>, Hash] \[args, options]
	def extract_extend_options *defaults
		args, o = _parse_o(defaults)
		args1, o1 = _parse_o(self)
		[args+args1, o.merge(o1)]
	end

	# modify args IN PLACE.
	# @ see extract_extend_options
	#
	# @example
	#   def foo(*args)
	#     options = args.extract_extend_options!
	#   end
	#
	#   foo(1, :a, :_b, c: 2)
	#     #=> args is [1]
	#     #=> o is {a: true, b: false, c:2}
	#   
	# @param [Symbol, Hash] *defaults
	# @return [Hash] options
	def extract_extend_options! *defaults
		args, o = extract_extend_options *defaults
		self.replace args
		o
	end

	# @param [Array,Hash] args
	def _parse_o args
		args = args.dup
		# name:1
		o1 = Hash === args.last ? args.pop : {}
		# :force :_force
		rst = args.select{|v| Symbol===v}
		args.delete_if{|v| Symbol===v}
		o2={}
		rst.each do |k|
			v = true
			if k=~/^_/
				k = k[1..-1].to_sym
				v = false
			end
			o2[k] = v
		end
		[args, o1.merge(o2)]
	end
	private :_parse_o
=end

	# Extracts options from a set of arguments. Removes and returns the last
	# element in the array if it's a hash, otherwise returns a blank hash.
	# you can also pass a default option.
	#
	# @example
	#   def options(*args)
	#     o = args.extract_options!(:a=>1)
	#   end
	#
	#   options(1, 2)           # => {:a=>1}
	#   options(1, 2, :a => :b) # => {:a=>:b}
	#
	# @param [Hash] default default options
	# @return [Hash]
	def extract_options! default={}
		if self.last.is_a?(Hash) && self.last.instance_of?(Hash)
			self.pop.merge default
		else
			default
		end
	end

	# extract options
	# @see extract_options!
	# @example
	#   def mkdir(*args)
	#     paths, o = args.extract_options
	#   end
	#
	# @return [Array<Array,Hash>] 
	def extract_options default={}
		if self.last.is_a?(Hash) && self.last.instance_of?(Hash)
			[self[0...-1], self[-1].merge(default)]
		else
			[self, default]
		end
	end

end