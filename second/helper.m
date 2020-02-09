% Creates two perl scripts to help us replace contents of certain files

%% create perl script to remove latex preamble
fid = fopen('./tools/strip_header.pl','w');
fprintf(fid,'my $fin = $ARGV[0];\n');
fprintf(fid,'my $fout = $ARGV[1];\n');
fprintf(fid,'open(FDIN,"<$fin") or die "Cannot open $fin for reading: $!\\n";\n');
fprintf(fid,'open(FDOUT,">$fout") or die "Cannot open $fout for writing: $!\\n";\n');
fprintf(fid,'my $preamble=1;\n');
fprintf(fid,'while (<FDIN>) {\n');
fprintf(fid,'    if (/begin\\{document\\}/) {\n');
fprintf(fid,'	       $preamble = 0;\n');
fprintf(fid,'	       next;\n');
fprintf(fid,'    \n}');
fprintf(fid,'    next if (/end\\{document\\}/);\n');
fprintf(fid,'    print FDOUT if ($preamble == 0);\n');
fprintf(fid,'}\n');
fprintf(fid,'close(FDOUT);\n');
fprintf(fid,'close(FDIN);\n');
fclose(fid);


%% 
source = struct();
source.resultSource.path = '/home/sugarkhuu/Documents/Documents/my/modelling/second';

flds = fieldnames(source);
fid = fopen('./tools/replace.pl','w');
fprintf(fid,'my $fin = $ARGV[0];\n');
fprintf(fid,'my $fout = $ARGV[1];\n');
fprintf(fid,'open(FDIN,"<$fin") or die "Cannot open $fin for reading: $!\\n";\n');
fprintf(fid,'open(FDOUT,">$fout") or die "Cannot open $fout for writing: $!\\n";\n');
fprintf(fid,'while (<FDIN>) {\n');
for i=1:numel(flds)
p = source.(flds{i}).path;
p = strrep(p, '\', '/');
p = strrep(p, '/', '\/');
fprintf(fid,'  s/\\@%s\\@/%s/g;\n', flds{i}, p);
end
fprintf(fid,'  print FDOUT;\n');
fprintf(fid,'}\n');
fprintf(fid,'close(FDOUT);\n');
fprintf(fid,'close(FDIN);\n');
fclose(fid);