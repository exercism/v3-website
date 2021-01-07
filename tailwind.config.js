module.exports = {
  future: {
    removeDeprecatedGapUtilities: true,
    // purgeLayersByDefault: true,
  },
  purge: [
    './app/views/**/*.haml',
    './app/helpers/**/*.rb',
    './app/css/**/*.css',
    './app/javascript/**/*',
  ],
  theme: {
    borderRadius: {
      none: '0',
      '3': '3px',
      '5': '5px',
      '8': '8px',
      '12': '12px',
      '100': '100px',
      circle: '100%',
    },
    borderWidth: {
      '0': '0',
      '1': '1px',
      '2': '2px',
      '3': '3px',
      '4': '4px',
    },
    boxShadow: {
      sm: '0px 4px 16px 0px rgb(79, 114, 205, 0.1)',
      base: '0px 4px 24px 0px rgba(79, 114, 205, 0.15)',
      lg: '0px 4px 42px 0px rgba(79, 114, 205, 0.15)',
    },
    colors: {
      transparent: 'transparent',
      current: 'currentColor',

      /* NEW */
      darkThemeBackgroundColor: 'var(--darkThemeBackgroundColor)',

      backgroundColorA: 'var(--backgroundColorA)',
      backgroundColorB: 'var(--backgroundColorB)',
      backgroundColorC: 'var(--backgroundColorC)',
      borderColor4: 'var(--borderColor4)',
      borderColor5: 'var(--borderColor5)',
      borderColor7: 'var(--borderColor7)',
      textColor1: 'var(--textColor1)',
      textColor5: 'var(--textColor5)',
      textColor6: 'var(--textColor4)',
      textColor9: 'var(--textColor9)',

      inputBackgroundColor: 'var(--inputBackgroundColor)',
      inputBorderColorFocus: 'var(--inputBorderColorFocus)',
      tabBackgroundColorSelected: 'var(--tabBackgroundColorSelected)',
      tabColorSelected: 'var(--tabColorSelected)',

      /* LEGACY*/
      textBase: 'var(--textColor5)',
      textLight: 'var(--textColor6)',

      unnamed10: '#3D3B45',
      unnamed13: '#33363F',
      unnamed15: '#F0F3F9',
      unnamed16: '#8480A0',
      randomBlue: '#F9F8FF',
      lightGold: '#FFD38F',

      bgGray: '#FBFCFE',
      lightGray: '#EAECF3',
      borderLight: '#CBC9D9',

      lightBlue: '#2E57E8',
      darkBlue: '#6A93FF',
      veryLightBlue: '#E1EBFF',

      purple: 'rgba(103, 93, 172, 1)',
      lightPurple: '#B0A8E3',
      anotherPurple: '#604FCD',

      gray: '#A9A6BD',
      darkGray: '#26282D',

      darkGreen: '#43B593',
      mediumGreen: '#B8EADB',
      lightGreen: '#ABDBCC',
      veryLightGreen: 'rgba(79,205,167,0.15)',

      tooManyGreens: '#59D2AE',
      literallySoManyGreens: '#4FCDA7',
      soManyGreens: '#228466',
      bgGreen: 'rgba(89, 210, 174, 0.15)',

      orange: '#F69605',
      lightOrange: '#FFF3E1',
      red: '#EB5757',
      lightRed: '#fdeaea',
      bgRed: 'rgba(235, 87, 87, 0.15)',
      gold: '#E2CB2D',

      commonBadge: '#F0F3F9',
      rareBadge: '#9FB4FF',

      black: '#000',
      white: '#fff',
    },
    fontFamily: {
      body: ['Poppins', 'sans-serif'],
      mono: ['Source Code Pro', 'monospace'],
    },
    fontSize: {
      '12': '12px',
      '13': '13px',
      '14': '14px',
      '15': '15px',
      '16': '16px',
      '18': '18px',
      '20': '20px',
      '22': '22px',
      '24': '24px',
      '25': '25px',
      '31': '31px',
      '40': '40px',
      '64': '64px',
    },
    height: {
      '48': '48px',
    },
    lineHeight: {
      none: '1',
      tight: '125%',
      regular: '138%',
      paragraph: '150%',
      code: '160%',
      huge: '170%',
    },
    spacing: {
      auto: 'auto',
      '0': '0px',
      '4': '4px',
      '6': '6px',
      '8': '8px',
      '12': '12px',
      '16': '16px',
      '20': '20px',
      '24': '24px',
      '28': '28px',
      '32': '32px',
      '36': '36px',
      '40': '40px',
      '48': '48px',
      '56': '56px',
      '64': '64px',
      '80': '80px',
      '128': '128px',
      spacedColumns: '70px',
    },
    width: {
      // Sometimes, elements need to have *some* width set
      // to then respond to flex-grow. This is used for that.
      auto: 'auto',
      arbitary: '1px',
      '5-7': '41.6%',
      '1-3': '33.3%',
      '1-2': '50%',
      '100': '100%',
    },
    zIndex: {
      '-1': '-1',
      '-2': '-2',
      '-3': '-3',
      '-4': '-4',
    },
  },
  variants: {},
  plugins: [],
  corePlugins: {
    container: false,
  },
  // s- for style
  prefix: 'tw-',
}
