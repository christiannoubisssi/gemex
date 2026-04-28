import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    // Seul un admin authentifié peut inviter
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Non autorisé' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    const { email, role, nom } = await req.json();
    if (!email || !role) {
      return new Response(JSON.stringify({ error: 'email et role requis' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    // Client admin avec service_role
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
    );

    const { data, error } = await supabaseAdmin.auth.admin.inviteUserByEmail(email, {
      data: { role, nom: nom ?? '' },
      redirectTo: `${Deno.env.get('APP_URL') ?? ''}/login`,
    });

    if (error) throw error;

    // Créer l'entrée dans la table profiles
    await supabaseAdmin.from('profiles').upsert({
      id: data.user.id,
      email,
      role,
      nom: nom ?? '',
      actif: true,
    });

    return new Response(JSON.stringify({ success: true, userId: data.user.id }), {
      status: 200,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: String(err) }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }
});
