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
      none: 'none',
      buttonS: '0px 4px 8px rgba(79, 114, 205, 0.4)',
      xsZ1: '0px 2px 4px 0px rgba(79, 114, 205, 0.3)',
      sm: '0px 4px 16px 0px rgb(79, 114, 205, 0.1)',
      base: '0px 4px 24px 0px rgba(79, 114, 205, 0.15)',
      baseZ1: '0px 4px 24px 0px rgba(79, 114, 205, 0.3)',
      lg: '0px 4px 42px 0px rgba(79, 114, 205, 0.15)',
      lgZ1: '0px 4px 42px 0px rgba(79, 114, 205, 0.3)',
      inputSelected: '0px 0px 2px 2px var(--inputBoxShadowColorFocus)',
    },
    colors: {
      transparent: 'transparent',
      current: 'currentColor',

      /* NEW */
      darkThemeBackgroundColor: 'var(--darkThemeBackgroundColor)',

      backgroundColorA: 'var(--backgroundColorA)',
      backgroundColorB: 'var(--backgroundColorB)',
      backgroundColorC: 'var(--backgroundColorC)',
      backgroundColorD: 'var(--backgroundColorD)',
      backgroundColorE: 'var(--backgroundColorE)',
      backgroundColorF: 'var(--backgroundColorF)',
      borderColor1: 'var(--borderColor1)',
      borderColor3: 'var(--borderColor3)',
      borderColor4: 'var(--borderColor4)',
      borderColor5: 'var(--borderColor5)',
      borderColor6: 'var(--borderColor6)',
      borderColor7: 'var(--borderColor7)',
      borderColor9: 'var(--borderColor9)',
      textColor1: 'var(--textColor1)',
      textColor2: 'var(--textColor2)',
      textColor3: 'var(--textColor3)',
      textColor5: 'var(--textColor5)',
      textColor6: 'var(--textColor6)',
      textColor7: 'var(--textColor7)',
      textColor8: 'var(--textColor8)',
      textColor9: 'var(--textColor9)',

      linkColor: 'var(--linkColor)',
      buttonBorderColor1: 'var(--buttonBorderColor1)',
      buttonBorderColor2: 'var(--buttonBorderColor2)',
      inputBackgroundColor: 'var(--inputBackgroundColor)',
      inputBorderColor: 'var(--inputBorderColor)',
      inputBorderColorFocus: 'var(--inputBorderColorFocus)',
      tabBackgroundColorSelected: 'var(--tabBackgroundColorSelected)',
      tabColorSelected: 'var(--tabColorSelected)',
      tabIconColorSelected: 'var(--tabIconColorSelected)',
      successColor: 'var(--successColor)',
      lockedColor: 'var(--lockedColor)',

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

      btnBorder: '#5C5589',
      primaryBtnBorder: '#130B43',
      purple: '#604FCD',
      purpleDarkened: '#3B2A93',
      anotherPurple: '#604FCD' /* Remove this */,
      lightPurple: '#B0A8E3',
      gotToLoveAPurple: '#271B72',
      biggerBolderAndMorePurpleThanEver: '#130B43',

      gray: '#A9A6BD',
      darkGray: '#26282D',

      darkGreen: '#43B593',
      mediumGreen: '#B8EADB',
      lightGreen: '#ABDBCC',
      veryLightGreen: 'rgba(79,205,167,0.15)',
      veryLightGreen2: '#E7FDF6',

      tooManyGreens: '#59D2AE',
      literallySoManyGreens: '#4FCDA7',
      soManyGreens: '#228466',
      bgGreen: 'rgba(89, 210, 174, 0.15)',
      everyoneLovesAGreen: '#349F7F',

      orange: '#F69605',
      lightOrange: '#FFF3E1',
      red: '#EB5757',
      lightRed: '#FDEAEA',
      veryLightRed: '#FFEDED',
      bgRed: 'rgba(235, 87, 87, 0.15)',
      gold: '#E2CB2D',
      brown: '#47300C',

      anotherGold: '#FAE54D',

      muddy: '#6E82AA',
      color22: '#C8D5EF',

      commonBadge: '#F0F3F9',
      rareBadge: '#9FB4FF',

      white: '#fff',
      black: '#000',
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
      '17': '17px',
      '18': '18px',
      '20': '20px',
      '21': '21px',
      '22': '22px',
      '23': '23px',
      '24': '24px',
      '25': '25px',
      '28': '28px',
      '31': '31px',
      '32': '32px',
      '40': '40px',
      '54': '54px',
      '64': '64px',
    },
    height: {
      '1': '1px',
      '48': '48px',
    },
    lineHeight: {
      none: '1',
      tight: '125%',
      regular: '138%',
      paragraph: '150%',
      code: '160%',
      huge: '170%',

      100: '100%',
      120: '120%',
      140: '140%',
      150: '150%',
      160: '160%',
      170: '170%',
      180: '180%',
      190: '190%',
      200: '200%',
    },
    spacing: {
      auto: 'auto',
      '0': '0px',
      '4': '4px',
      '6': '6px',
      '8': '8px',
      '10': '10px',
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
      '72': '72px',
      '80': '80px',
      '88': '88px',
      '96': '96px',
      '128': '128px',
      '140': '140px',
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
      '1': '1',
      overlay: '10',
      menu: '40',
      dropdown: '50',
      tooltip: '80',
      modal: '100',
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
