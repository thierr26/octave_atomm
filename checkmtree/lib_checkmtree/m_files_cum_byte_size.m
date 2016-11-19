## Copyright (C) 2016 Thierry Rascle <thierr26@free.fr>
## MIT license. Please refer to the LICENSE file.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{ret} =} m_files_cum_byte_size (@var{s})
##
## Cumulative byte size of the M-files found by 'find_m_toolboxes'.
##
## The argument @var{s} is supposed to have been returned by function
## @code{find_m_toolboxes}.  @code{@var{ret} = m_files_cum_byte_size (@var{s})}
## returns in @var{ret} the cumulative byte size of the M-files found by
## 'find_m_toolboxes' and mentioned in @var{s}.
##
## Only .m text files are taken into account.
##
## @seealso{find_m_toolboxes}
## @end deftypefn

## Author: Thierry Rascle <thierr26@free.fr>

function ret = m_files_cum_byte_size(s)

    mFilt = m_file_filters ('m_lang_only');
    mExt = file_ext(mFilt{1});
    ret = 0;
    for k = 1 : numel(s.mfiles)
        for kk = 1 : numel(s.mfiles{k})
            if strcmp(file_ext(s.mfiles{k}{kk}), mExt)
                ret = ret + s.mfilebytes{k}(kk);
            endif
        endfor
    endfor
    for k = 1 : numel(s.privatemfiles)
        for kk = 1 : numel(s.privatemfiles{k})
            if strcmp(file_ext(s.privatemfiles{k}{kk}), mExt)
                ret = ret + s.privatemfilebytes{k}(kk);
            endif
        endfor
    endfor

endfunction
