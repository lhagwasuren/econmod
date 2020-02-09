%% Preliminary session

% add IRIS to the path
% addpath /home/sugarkhuu/Documents/IRIS-Toolbox-Release-20200119
cd /home/sugarkhuu/Documents/Documents/my/modelling/second
addpath /home/sugarkhuu/Documents/IRIS-Toolbox-Release-20180319

% configure IRIS
irisstartup
irisversion

% adding path for xml2struct
addpath /home/sugarkhuu/Documents/Documents/my/modelling/second/tools

% create perl scripts to replace things later on
run('helper.m');

% remove temporary dir if it's already there
tmpdir = 'wdir';
if exist(tmpdir, 'dir')
   rmdir(tmpdir, 's');
end

%% Forecast
disp('Forecast starts ...');
p   = struct();
p.a = 0.7;

m = model('second.mod','linear',true,'assign',p);
m = solve(m);
m = sstate(m);

d=struct();
d.obs_x = tseries();
d.obs_x(qq(2018,1):qq(2019,4)) = [1.5 1.2 0.9 0.8 1.5 2.1 1.3 1.2];

[~, f, v, ~, pe, co] = filter(m, d, qq(2018,1):qq(2019,4)+10);

disp('Forecast finishes ...');

%% Report table

disp('Report table starts ...');

outDir = ['.' filesep 'results' filesep];
outname = 'reportTable.pdf';

if ~exist(outDir, 'dir')
   mkdir(outDir);
end

rep     = report.new('My Forecast Report','color', true,'colsep',0.1*10,'visible',false);
tblOpts = {'range',qq(2018,1):qq(2019,4)};

rep.table('',tblOpts{:},'dateFormat','YYYYFP','decimal',1);
rep.subheading('');

rep.subheading('Forecast values', 'bold', true);
rep.series('Series x',f.mean.x);
rep.series('Series e',f.mean.e);
rep.subheading('');

outfile = [outDir filesep outname];

rep.publish(outfile,'deletelatex',false,'display',false, 'tempDir','wdir');

fileList = dir('./wdir/*.tex');
infilename = fileList(1).name;

% run the perl script
perl('./tools/strip_header.pl',['./wdir/' infilename],['./results/tables/myTable.tex']);
  
disp('Report table finishes ...');

%% Report figure

disp('Report figure starts ...');

outDirFig = './results/figures';
if ~exist(outDirFig, 'dir')
   mkdir(outDirFig);
end

rep = report.new('My Forecast Report','color', true,'visible',false);

fx = figure('visible','off');
plot(f.mean.x);  
grid;           
rep.userfigure(['my x series'], fx);

print('-depsc2',[outDirFig filesep 'my_x.eps']);

fe = figure('visible','off');
plot(f.mean.e);  
grid;           
rep.userfigure(['my e series'], fe);

print('-depsc2',[outDirFig filesep 'my_e.eps']);
  
disp('Report figure finishes ...');

%% Report text

disp('Report text starts ...');
repFile = ['./second.xml'];
xmlText = xml2struct(repFile);
xmlStruct = xmlText.alltext{2};

fd = fopen(['./results/texs/second_text.tex'],'w');

introList = {'introl', 'intror'};
 
 % begin intro block
 for i=1:numel(introList)
    introPar = xmlStruct.intro.(introList{i}).par.Text;
    txtIn = introPar;
    fprintf(fd, '\\def\\%s{%s}\n\n',introList{i},txtIn);
 end
% end intro block
 
napar   = numel(xmlStruct.bodytext.apar);
npar    = numel(xmlStruct.bodytext.par);

for i = 1:npar
    xmlStruct.bodytext.apar{napar+i} = xmlStruct.bodytext.par{i};
end

% begin bodytext block
fprintf(fd, '\\def\\bodytext{\n'); 
for i=1:numel(xmlStruct.bodytext.apar)
    fprintf(fd, '%s\n\n',xmlStruct.bodytext.apar{i}.Text);
end
fprintf(fd, '}\n'); 
% end bodytext block

% end infolist block  
for i=1:numel(xmlStruct.infolist.info)
    idtag = xmlStruct.infolist.info{i}.idtag.Text;
    txtIn = xmlStruct.infolist.info{i}.par.Text;
    fprintf(fd, '\\def\\%s{%s}\n\n',idtag,txtIn);
end
% end infolist block

fclose(fd);

disp('xml parsing done ...'); 

disp('Report text finishes ...');
%% Replacement
tmpdir = './wdir';
if ~exist(tmpdir, 'dir')
   mkdir(tmpdir);
end

perl('./tools/replace.pl', 'second.tex', [tmpdir filesep 'tmp.tex']);


disp('Compiling PDF ...');
irisconf = irisget;
display = '';
cd(tmpdir);
[status, report] = system(['"',irisconf.pdflatexpath,'" -shell-escape -interaction=nonstopmode "','tmp.tex','"',display]);
movefile tmp.pdf ../results/finalResult.pdf


disp('Done!')
