local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	return
end

alpha.setup(require('alpha.themes.dashboard').config)
