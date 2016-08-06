;; Minimal .emacs setup for using latest org-mode, org-mode babel,
;; fancy exports and all that.


(require 'package)
(setq package-archives '(("org" . "http://orgmode.org/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages")
			 ("marmalade"."http://marmalade-repo.org/packages/")
			 ("melpa"."http://melpa.org/packages/")))
(package-initialize)

(defun ensure-package-installed (&rest packages)
  "Download the package if it were not installed"
  (mapcar
   (lambda (package)
     (if (not (package-installed-p package))
         (progn
           (package-refresh-contents)
           (package-install package))))
   packages))

(ensure-package-installed
 'exec-path-from-shell
 'gnuplot
 'org-plus-contrib)

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(global-visual-line-mode t)
(setq inhibit-startup-message t)
(show-paren-mode t)
(setq-default indent-tabs-mode nil)
;; mouse scroll
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((gnuplot . t)
   (python . t)
   (R . t)
   (ditaa t)
   (perl . t)))
(setq org-startup-with-inline-images t)
(setq org-pretty-entities t)
(setq org-confirm-babel-evaluate nil)
(add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)

(setq org-publish-project-alist
      '(("notes-files"
         :base-directory "~/notes"
         :exclude "public_html"
         :publishing-directory "~/notes/public_html/"
         :publishing-function org-html-publish-to-html)
        ("notes-assets"
         :base-directory "~/notes/"
         :exclude "public_html"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "~/notes/public_html/"
         :publishing-function org-publish-attachment
         :recursive t)
        ("notes"
         :components ("notes-files" "notes-assets"))))

;; The defaults mathjax is old and slow
(setf org-html-mathjax-options
      '((path "https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML")
        (scale "100")
        (align "center")
        (indent "2em")
        (mathml nil)))
(setf org-html-mathjax-template
    "<script type=\"text/javascript\" src=\"%PATH\"></script>")
