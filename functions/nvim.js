export async function onRequest(context) {
  const rawUrl = 'https://raw.githubusercontent.com/eeriemyxi/dotfiles/refs/heads/main/.config/nvim/init.lua';

  try {
    const response = await fetch(rawUrl);

    if (!response.ok) {
      return new Response(`Failed to fetch file. GitHub API status: ${response.status}`, { status: response.status });
    }

    const textContent = await response.text();
    
    return new Response(textContent, {
      headers: { 'Content-Type': 'text/plain; charset=utf-8' }
    });

  } catch (error) {
    return new Response(`Internal Server Error: ${error.message}`, { status: 500 });
  }
}
