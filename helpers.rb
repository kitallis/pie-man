class String
  def wordwrap(len)
   	gsub( /\n/, "\n\n" ).gsub( /(.{1,#{len}})(\s+|$)/, "\\1\n" )
  end
end

def redirect
	orig_defout = $stdout
  $stdout = StringIO.new
  yield
  $stdout.string
  ensure $stdout = orig_defout
end
