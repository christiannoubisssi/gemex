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
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Non autorisé' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    const { email, role, nom, password } = await req.json() as {
      email: string; role: string; nom?: string; password?: string;
    };

    if (!email || !role) {
      return new Response(JSON.stringify({ error: 'email et role requis' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
    );

    // createUser avec email_confirm: true — compte actif immédiatement, sans email
    const { data, error } = await supabaseAdmin.auth.admin.createUser({
      email,
      password: password ?? `Gemex@${Math.random().toString(36).slice(2, 10)}`,
      email_confirm: true,
      user_metadata: { role, nom: nom ?? '' },
    });

    if (error) throw error;

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
