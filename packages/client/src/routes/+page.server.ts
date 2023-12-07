import { redirect } from '@sveltejs/kit'

// Auto redirect to /dashboard
export async function load({ params }) {
	// Specify the route you want to redirect to
	const redirectTo = '/dashboard'

	// Perform the redirection
	throw redirect(302, redirectTo)
}
