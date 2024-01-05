config.load_autoconfig()

# ui
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.enabled = False
c.colors.webpage.darkmode.algorithm = "lightness-cielab"
c.colors.webpage.darkmode.policy.page = "smart"
c.colors.webpage.darkmode.policy.images = "never"

# start page
c.url.default_page = 'https://home-revise.netlify.app'
c.url.start_pages = 'https://home-revise.netlify.app'

# editoring
c.editor.command = ['kitty', 'nvim', '{}']

# keybinds
c.bindings.commands = {
    'normal': {
        # tab focus to ctrl
        '<Ctrl-1>': 'tab-focus 1',
        '<Ctrl-2>': 'tab-focus 2',
        '<Ctrl-3>': 'tab-focus 3',
        '<Ctrl-4>': 'tab-focus 4',
        '<Ctrl-5>': 'tab-focus 5',
        '<Ctrl-6>': 'tab-focus 6',
        '<Ctrl-7>': 'tab-focus 7',
        '<Ctrl-8>': 'tab-focus 8',
        '<Ctrl-9>': 'tab-focus -1',
        # config edit/source
        ',ce': 'config-edit',
        ',cs': 'config-source',
        ',cT': 'config-cycle content.proxy system socks://localhost:9050',
        # misc
        ',pf': 'spawn --userscript password_fill',
        'gA': 'set-cmd-text -s :tab-take',
    },
    'insert': {
        '<Ctrl-y>': 'spawn --userscript password_fill',
    },
    'passthrough': {
        '<Escape>': 'mode-leave',
    }
}

# search engines
c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    'aw': 'https://wiki.archlinux.org/?search={}',
    'ap': 'https://archlinux.org/packages/?q={}',
    'aur': 'https://aur.archlinux.org/packages/?K={}',
    'pp': 'https://pypi.org/search/?q={}',
    'tp': 'https://ctan.org/search?phrase={}',
    'tse': 'https://tex.stackexchange.com/search?q={}',
    'sr': 'https://www.reddit.com/r/{}',
    'rs': 'https://www.reddit.com/search/?q={}',
    'gmap': 'https://maps.google.com/maps/search/{}',
    'gs': 'https://scholar.google.com/scholar?q={}',
    'eb': 'https://www.ebay.com/sch/i.html?_nkw={}',
    'az': 'https://www.amazon.com/s?k={}',
    'lt': 'https://www.linktr.ee/{}',
    'tu': 'https://www.tinyurl.com/{}',
    'gl': 'https://genius.com/search?q={}',
    'st': 'https://simpletracking.com/track/{}',
    'bf': 'https://www.bookfinder.com/isbn/{}',
    'lg': 'https://libgen.is/search.php?req={}',
    'dd': 'https://downdetector.com/search/?q={}'
}

# fingerprinting--;
c.content.headers.user_agent = 'Mozilla/5.0 (X11; Linux x86_64) Chrome/114.0'
c.content.headers.accept_language = 'en-US,en;q=0.5'
c.content.headers.custom = {"accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"}
c.content.geolocation = False
c.content.canvas_reading = False
c.content.default_encoding = 'utf-8'
# c.content.proxy = 'socks://localhost:9050/'

# adblock++;
c.content.blocking.enabled = True
c.content.blocking.method = 'both'
c.content.blocking.hosts.lists = [
    'https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn-social/hosts',
    'https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts',
    '/home/revise/.config/qutebrowser/blocked-hosts'
]

# misc
c.spellcheck.languages = ['en-US']
c.content.pdfjs = True
c.downloads.remove_finished = 5000
c.qt.args = ['disable-accelerated-2d-canvas']

# domainwise? help me :sob:
