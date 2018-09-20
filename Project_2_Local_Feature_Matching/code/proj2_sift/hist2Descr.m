
function [feat] = hist2Descr(feat,descr,descr_mag_thr)
% Function: Convert histogram to descriptor
descr = descr/norm(descr);
descr = min(descr_mag_thr,descr);
descr = descr/norm(descr);
feat.descr = descr;
end
