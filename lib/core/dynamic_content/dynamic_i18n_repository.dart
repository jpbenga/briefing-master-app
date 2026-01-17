import 'dynamic_i18n_models.dart';

class DynamicI18nRepository {
  List<Scenario> fetchScenarios() {
    return const [
      Scenario(
        id: 'crisis_revenue_drop',
        title: DynamicI18nText({
          'en': 'Crisis Meeting: Revenue Drop',
          'fr': 'Réunion de crise : chute du revenu',
          'es': 'Reunión de crisis: caída de ingresos',
          'pt': 'Reunião de crise: queda de receita',
          'de': 'Krisenmeeting: Umsatzrückgang',
        }),
        description: DynamicI18nText({
          'en':
              'You must brief leadership on the situation, propose a root-cause path, and commit to a recovery plan — under pressure.',
          'fr':
              'Vous devez briefer la direction, proposer une piste de cause racine et vous engager sur un plan de reprise — sous pression.',
          'es':
              'Debes informar al liderazgo, proponer una causa raíz y comprometerte con un plan de recuperación — bajo presión.',
          'pt':
              'Você deve informar a liderança, propor a causa raiz e se comprometer com um plano de recuperação — sob pressão.',
          'de':
              'Du musst die Führung informieren, eine Ursachenanalyse vorschlagen und dich zu einem Erholungsplan verpflichten — unter Druck.',
        }),
        intent: DynamicI18nText({
          'en': 'Sharing bad news',
          'fr': 'Partager une mauvaise nouvelle',
          'es': 'Compartir malas noticias',
          'pt': 'Compartilhar más notícias',
          'de': 'Schlechte Nachrichten teilen',
        }),
      ),
      Scenario(
        id: 'reporting_delay',
        title: DynamicI18nText({
          'en': 'Delivery Update: Reporting a Delay',
          'fr': 'Mise à jour : signaler un retard',
          'es': 'Actualización: informar un retraso',
          'pt': 'Atualização: reportar um atraso',
          'de': 'Update: Eine Verzögerung melden',
        }),
        description: DynamicI18nText({
          'en':
              'Explain the delay, communicate dependencies, and offer a revised ETA with confidence.',
          'fr':
              'Expliquez le retard, clarifiez les dépendances et proposez un nouvel ETA avec assurance.',
          'es':
              'Explica el retraso, aclara dependencias y ofrece un nuevo ETA con seguridad.',
          'pt':
              'Explique o atraso, detalhe dependências e ofereça um novo ETA com confiança.',
          'de':
              'Erkläre die Verzögerung, kommuniziere Abhängigkeiten und nenne eine neue ETA mit Sicherheit.',
        }),
        intent: DynamicI18nText({
          'en': 'Reporting a delay',
          'fr': 'Signaler un retard',
          'es': 'Informar un retraso',
          'pt': 'Reportar um atraso',
          'de': 'Eine Verzögerung melden',
        }),
      ),
    ];
  }
}
