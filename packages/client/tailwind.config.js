export default {
	content: ['./src/**/*.{html,js,svelte,ts}'],
	theme: {
		extend: {
			fontFamily: {
				jura: ['Jura', 'sans-serif'],
				digital: ['digital-clock']
			},
			backgroundColor: {
				'transparent-grey': 'rgba(47, 47, 50, 0.29)', // Customize the alpha value to set the transparency level you desire
				'highlight-transparent-grey': 'rgba(60, 61, 61, 0.4)' // Customize the alpha value to set the transparency level you desire
			}
		}
	},
	plugins: []
}
