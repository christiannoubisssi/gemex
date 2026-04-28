import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';

const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY') ?? '';
const FROM_EMAIL = Deno.env.get('FROM_EMAIL') ?? 'no-reply@votrecabinet.ga';
const CABINET_NOM = Deno.env.get('CABINET_NOM') ?? "Cabinet d'Expertise Maritime";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const { type, recipientEmail, recipientName, documentNumero, montant, pdfBase64 } =
      await req.json();

    const nom = recipientName ?? recipientEmail;
    let subject = '';
    let html = '';

    if (type === 'devis') {
      subject = `Devis ${documentNumero} — ${CABINET_NOM}`;
      html = `
        <p>Bonjour ${nom},</p>
        <p>Veuillez trouver ci-joint votre devis <strong>${documentNumero}</strong>
           d'un montant TTC de <strong>${montant ? Number(montant).toLocaleString('fr-FR') + ' FCFA' : ''}</strong>.</p>
        <p>Pour toute question, n'hésitez pas à nous contacter.</p>
        <p>Cordialement,<br>${CABINET_NOM}</p>
      `;
    } else if (type === 'facture') {
      subject = `Facture ${documentNumero} — ${CABINET_NOM}`;
      html = `
        <p>Bonjour ${nom},</p>
        <p>Veuillez trouver ci-joint votre facture <strong>${documentNumero}</strong>
           d'un montant TTC de <strong>${montant ? Number(montant).toLocaleString('fr-FR') + ' FCFA' : ''}</strong>.</p>
        <p>Merci de procéder au règlement dans les délais convenus.</p>
        <p>Cordialement,<br>${CABINET_NOM}</p>
      `;
    } else if (type === 'relance') {
      subject = `Rappel de paiement — Facture ${documentNumero}`;
      html = `
        <p>Bonjour ${nom},</p>
        <p>Nous vous rappelons que la facture <strong>${documentNumero}</strong>
           d'un montant de <strong>${montant ? Number(montant).toLocaleString('fr-FR') + ' FCFA' : ''}</strong>
           est en attente de règlement.</p>
        <p>Nous vous remercions de bien vouloir régulariser cette situation dans les plus brefs délais.</p>
        <p>Cordialement,<br>${CABINET_NOM}</p>
      `;
    } else {
      return new Response(JSON.stringify({ error: 'type invalide' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    const payload: Record<string, unknown> = {
      from: `${CABINET_NOM} <${FROM_EMAIL}>`,
      to: [recipientEmail],
      subject,
      html,
    };

    if (pdfBase64) {
      payload.attachments = [
        {
          filename: `${documentNumero}.pdf`,
          content: pdfBase64,
        },
      ];
    }

    const res = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${RESEND_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });

    const data = await res.json();

    if (!res.ok) {
      throw new Error(JSON.stringify(data));
    }

    return new Response(JSON.stringify({ success: true, id: data.id }), {
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
