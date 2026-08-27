// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get homeTitle =>
      'A Internet não funciona?\nInstável? Funciona parcialmente?';

  @override
  String get homeDiagnoseButton => 'Encontrar o problema e indicar uma solução';

  @override
  String get homeUrlPrompt =>
      'Um site ou serviço específico não está a funcionar?\nCole aqui o link (URL):';

  @override
  String get homeUrlHint => 'example.com or https://example.com/page';

  @override
  String get homeCheckButton => 'Verificar';

  @override
  String get homeSettingsTooltip => 'Definições';

  @override
  String get homeRunningDiagnosis => 'A executar verificação completa…';

  @override
  String get homeRunningUrlCheck => 'A verificar o site…';

  @override
  String get homeCheckFailedTitle => 'Não foi possível concluir a verificação';

  @override
  String get homeUnknownError => 'Erro desconhecido';

  @override
  String get homeTryAgain => 'Tentar novamente';

  @override
  String get commonBack => 'Voltar';

  @override
  String get settingsTitle => 'Definições';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsLanguageCaption =>
      'Toda a aplicação está traduzida, incluindo os resultados do diagnóstico e os seus detalhes técnicos.';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Escuro';

  @override
  String get settingsFontSize => 'Tamanho do texto';

  @override
  String get settingsFontSmall => 'Pequeno';

  @override
  String get settingsFontNormal => 'Normal';

  @override
  String get settingsFontLarge => 'Grande';

  @override
  String get settingsCheckForUpdate => 'Verificar atualizações';

  @override
  String get settingsBuyMeACoffee => 'Ofereça-me um café';

  @override
  String get resultWhatToDo => 'O que fazer';

  @override
  String get resultDialogNotNow => 'Agora não';

  @override
  String get resultDialogYes => 'Sim';

  @override
  String get resultNothingToOpen => 'Não há nada para abrir nesta etapa.';

  @override
  String resultActionFailed(String error) {
    return 'Não foi possível concluir essa ação: $error';
  }

  @override
  String resultCapabilityTitle(int fits, int total) {
    return 'O que a sua ligação permite fazer ($fits de $total)';
  }

  @override
  String get resultUploadNotMeasured =>
      'Não foi possível medir o envio (upload), pelo que não foi avaliado.';

  @override
  String get techDetailsTitle => 'Detalhes técnicos';

  @override
  String get techDetailsCopy => 'Copiar';

  @override
  String get techDetailsCopied => 'Detalhes técnicos copiados.';

  @override
  String get urlOpenInBrowser => 'Abrir no navegador';

  @override
  String get urlCheckAnother => 'Verificar outro';

  @override
  String get urlCouldNotOpenBrowser => 'Não foi possível abrir o navegador.';

  @override
  String urlCouldNotOpen(String error) {
    return 'Não foi possível abrir: $error';
  }

  @override
  String get urlNothingToTestAgain => 'Não há nada para testar novamente.';

  @override
  String urlCouldNotOpenSettings(String error) {
    return 'Não foi possível abrir as definições: $error';
  }

  @override
  String get crossMediumTestOverMobile => 'Testar com dados móveis';

  @override
  String get crossMediumTestOverWifi => 'Testar com Wi-Fi';

  @override
  String get crossMediumHintMobile =>
      'Desative o Wi-Fi e depois volte — a verificação é executada novamente sozinha.';

  @override
  String get crossMediumHintWifi =>
      'Ative o Wi-Fi e depois volte — a verificação é executada novamente sozinha.';

  @override
  String get verdictFlightModeTitle => 'Está em modo de voo';

  @override
  String get verdictFlightModeDetail =>
      'A ligação sem fios está desligada, por isso nada consegue chegar à Internet enquanto o modo de voo estiver ativo.';

  @override
  String get solutionFlightModeMessage =>
      'Desligue o modo de voo e tente novamente.';

  @override
  String get verdictNotConnectedTitle => 'Sem ligação a qualquer rede';

  @override
  String get verdictNotConnectedDetail =>
      'O Wi-Fi e os dados móveis parecem ambos desligados, por isso não há forma de chegar à Internet.';

  @override
  String get solutionNotConnectedMessage =>
      'Ligue o Wi-Fi ou os dados móveis e tente novamente.';

  @override
  String get verdictRouterNotRespondingTitle => 'O router não responde';

  @override
  String verdictRouterNotRespondingDetail(String where) {
    return 'Está ligado à rede, mas $where não responde. Pode ter bloqueado ou ficado sem energia.';
  }

  @override
  String verdictRouterWhereNamed(String gateway) {
    return 'o seu router ($gateway)';
  }

  @override
  String get verdictRouterWhereUnnamed => 'o seu router';

  @override
  String get solutionRouterNotRespondingMessage =>
      'Reinicie o router: desligue-o da tomada, aguarde 30 segundos, volte a ligá-lo e dê-lhe cerca de 2 a 5 minutos para arrancar. Depois execute o teste novamente.';

  @override
  String get verdictCaptivePortalTitle =>
      'Início de sessão necessário (portal cativo)';

  @override
  String get verdictCaptivePortalDetail =>
      'A rede quer que inicie sessão ou aceite termos numa página web antes de o deixar navegar — comum em hotéis, cafés e aeroportos.';

  @override
  String get solutionCaptivePortalMessage =>
      'Abra a página de início de sessão e conclua a autenticação, depois execute o teste novamente.';

  @override
  String get verdictNoInternetMobileTitle =>
      'Ligado aos dados móveis, mas sem Internet';

  @override
  String get verdictNoInternetMobileDetail =>
      'O telemóvel chega à rede a um nível básico, mas não tem um caminho funcional para a Internet. Isto aponta para um problema na rede do seu operador, não no telemóvel.';

  @override
  String get solutionNoInternetMobileMessage =>
      '1. Ligue e desligue o modo de voo, ou reinicie o telemóvel, para voltar a ligar a uma antena nova.\n2. Se o teste continuar a falhar após 2 a 5 minutos, contacte o seu operador móvel — a falha é do lado deles.';

  @override
  String get verdictNoInternetIspTitle => 'Ligado ao router, mas sem Internet';

  @override
  String get verdictNoInternetIspDetail =>
      'O router funciona, mas não tem uma ligação funcional ao seu fornecedor de Internet (ISP). O problema está fora de sua casa.';

  @override
  String get solutionNoInternetIspMessage =>
      '1. Verifique se o router está ligado à tomada de telefone/DSL na parede.\n2. Verifique se o cabo não está danificado nem solto.\n3. Se tiver um telefone fixo, levante o auscultador e ouça o sinal de marcação. Se não ouvir sinal, contacte a sua operadora de telefone e/ou o fornecedor de Internet para reparar a linha.\n4. Reinicie o router uma vez para restabelecer a ligação ao ISP. Se o teste continuar a falhar após 2 a 5 minutos, contacte o seu fornecedor de Internet — a falha é do lado deles.';

  @override
  String get verdictMobileNoDataTitle =>
      'Os dados móveis estão ligados mas não funcionam';

  @override
  String get verdictMobileNoDataDetail =>
      'O telemóvel está na rede móvel, mas não passam dados. Normalmente significa que o roaming de dados está desligado, que esgotou o seu plafom de dados, ou que o operador tem uma falha local.';

  @override
  String solutionMobileNoDataMessage(String reception) {
    return '1. Se estiver no estrangeiro ou noutra rede, ligue o roaming de dados nas definições da rede móvel.\n2. Verifique se ainda tem dados disponíveis no seu plano.\n3. $reception\n4. Se continuar a falhar, contacte o seu operador móvel.';
  }

  @override
  String solutionMobileNoDataReception(String signal) {
    String _temp0 = intl.Intl.selectLogic(signal, {
      'good': 'Desligue e volte a ligar os dados móveis.',
      'weak':
          'O seu sinal está fraco: vá para um sítio com melhor receção e desligue e volte a ligar os dados móveis.',
      'other':
          'Vá para um sítio com melhor sinal, ou desligue e volte a ligar os dados móveis.',
    });
    return '$_temp0';
  }

  @override
  String get verdictDnsProblemTitle => 'Problema de DNS';

  @override
  String get verdictDnsProblemDetail =>
      'A Internet está acessível, mas os nomes dos sites não estão a ser traduzidos em endereços. É um problema de DNS e costuma ser fácil de resolver mudando para um resolvedor de DNS público.';

  @override
  String get solutionDnsProblemMessageMobile =>
      '1. Mude o seu DNS privado para um resolvedor público fiável como 1.1.1.1 (Cloudflare) ou 8.8.8.8 (Google) e teste de novo.\n2. Se continuar a falhar, desligue e volte a ligar os dados móveis, ou reinicie o telemóvel, para obter uma ligação nova.\n3. Se continuar a falhar, contacte o seu operador móvel — alguns operadores têm resolvedores de DNS próprios que têm falhas por si sós.';

  @override
  String get solutionDnsProblemMessageFixed =>
      '1. Mude o seu DNS privado para um resolvedor público fiável como 1.1.1.1 (Cloudflare) ou 8.8.8.8 (Google) e teste de novo.\n2. Se estiver numa rede gerida (trabalho, escola, Wi-Fi público), contacte o administrador da rede para corrigir o DNS.\n3. Se estiver na sua própria rede, verifique as definições do router. É boa prática configurar também o DNS secundário para um resolvedor público (exemplos: 1.1.1.1, 4.4.4.4, 4.4.2.2, 8.8.8.8), caso o primário (o seu fornecedor de Internet) falhe.';

  @override
  String verdictPortBlockedTitle(String port) {
    return 'A porta $port está bloqueada';
  }

  @override
  String verdictPortBlockedDetail(String service, String port) {
    return 'O acesso geral à Internet funciona, mas o tráfego $service na porta $port está a ser bloqueado — provavelmente por uma firewall nesta rede. Algumas aplicações que dependem desta porta não funcionarão.';
  }

  @override
  String get solutionPortBlockedMobile =>
      'O seu operador móvel provavelmente bloqueia-a por política — experimente antes o Wi-Fi ou uma VPN, ou contacte o operador se precisar desta porta aberta na rede móvel.';

  @override
  String solutionPortBlockedFixed(String port) {
    return 'Se estiver ligado a uma rede gerida (trabalho, escola, Wi-Fi público), a porta $port está bloqueada por política — experimente antes os dados móveis ou uma VPN. Na sua rede, verifique as regras da firewall nas definições do router.';
  }

  @override
  String get verdictIspPathMobileTitle =>
      'Problema de caminho de rede no seu operador';

  @override
  String get verdictIspPathIspTitle => 'Problema de caminho de rede no seu ISP';

  @override
  String verdictIspPathDetailMobile(String hop) {
    return 'A ligação chega à Internet mas o tráfego para pelo caminho, depois de $hop. A falha está no seu operador móvel ou na rota de backbone, não no telemóvel.';
  }

  @override
  String verdictIspPathDetailFixed(String hop) {
    return 'A ligação chega à Internet mas o tráfego para pelo caminho, depois de $hop. A falha está no seu fornecedor de Internet ou na rota de backbone, não no seu dispositivo nem no router.';
  }

  @override
  String get verdictIspPathHopGenericMobile =>
      'um salto dentro do seu operador móvel';

  @override
  String get verdictIspPathHopGenericFixed =>
      'um salto dentro do seu fornecedor de Internet';

  @override
  String get solutionIspPathMessageMobile =>
      'Não há nada a corrigir no seu dispositivo nem na sua rede. Comunique a rota com falha ao seu operador móvel (mencione que o traceroute para a meio do caminho). Costuma resolver-se assim que corrigirem a rota.';

  @override
  String get solutionIspPathMessageFixed =>
      'Não há nada a corrigir no seu dispositivo nem na sua rede. Comunique a rota com falha ao seu fornecedor de Internet (mencione que o traceroute para a meio do caminho). Costuma resolver-se assim que corrigirem a rota.';

  @override
  String verdictCapabilityGoodTitle(String medium, String uses) {
    return 'O seu $medium é bom para $uses — e mais';
  }

  @override
  String verdictCapabilityGoodDetail(String measured) {
    return '$measured Se mesmo assim algo parecer errado, é muito provável que seja uma aplicação ou um site específico — não a sua ligação.';
  }

  @override
  String verdictCapabilityMostlyGoodTitle(String medium, String failing) {
    return 'O seu $medium é bom para tudo exceto para $failing';
  }

  @override
  String verdictCapabilityDegradedTitle(String medium, String failing) {
    return 'O seu $medium é demasiado fraco para $failing';
  }

  @override
  String verdictMeasuredBoth(String medium, String down, String up) {
    return 'Medido através de $medium:\ndescarregamento $down Mbps, envio $up Mbps.';
  }

  @override
  String verdictMeasuredDownOnly(String medium, String down) {
    return 'Medido através de $medium:\ndescarregamento $down Mbps.';
  }

  @override
  String verdictMeasuredUpOnly(String medium, String up) {
    return 'Medido através de $medium:\nenvio $up Mbps.';
  }

  @override
  String verdictMeasuredNone(String medium) {
    return 'Medido através de $medium.';
  }

  @override
  String get verdictUploadNotAssessed =>
      'O teste de envio não pôde ser executado, pelo que não foi avaliado.';

  @override
  String get verdictCauseGatewayWeak =>
      'O seu router responde devagar ou perde pacotes, o que aponta para o próprio Wi-Fi e não para o seu fornecedor.';

  @override
  String get verdictCauseSaturated =>
      'A ligação abranda bastante enquanto está ocupada. Alguém ou algo mais na sua rede (uma transferência, uma cópia de segurança, uma TV) está a usar a linha.';

  @override
  String get verdictCauseThroughput =>
      'A velocidade da ligação não é suficiente. Ou o seu plano de Internet é demasiado lento ou o seu fornecedor está a limitar a linha.';

  @override
  String get verdictCauseGeneric =>
      'Os tempos de resposta e a perda de pacotes variam demasiado para as atividades em tempo real mais exigentes.';

  @override
  String get adviceMoveCloser =>
      'Aproxime-se do router, ou experimente a rede de 5 GHz se o seu router oferecer uma.';

  @override
  String get advicePauseTheHog =>
      'Descubra quem ou o que está a usar muito a linha e peça para pausar. Caso contrário, espere, ou reinicie o Wi-Fi — isso também corta a ligação deles.';

  @override
  String get adviceDropTheCamera =>
      'Desligue a câmara — a sua ligação ainda consegue transportar o áudio.';

  @override
  String get actionTestAgain => 'Testar novamente';

  @override
  String get actionTestAgainWifi => 'Testar novamente por Wi-Fi';

  @override
  String get actionTestAgainMobile => 'Testar novamente por dados móveis';

  @override
  String get actionTurnOnWifi => 'Ligar o Wi-Fi';

  @override
  String get confirmTurnOnWifi =>
      'O Wi-Fi está desligado. Abrir as definições para o ligar?';

  @override
  String get actionTurnOnMobileData => 'Ligar os dados móveis';

  @override
  String get confirmTurnOnMobileData =>
      'Os dados móveis estão desligados. Abrir as definições para os ligar?';

  @override
  String get actionOpenFlightSettings => 'Abrir as definições do modo de voo';

  @override
  String get confirmFlightMode =>
      'Está em modo de voo. Abrir as definições para o desligar?';

  @override
  String get actionOpenSignInPage => 'Abrir a página de início de sessão';

  @override
  String get confirmCaptivePortal =>
      'Está bloqueado por uma página de início de sessão. Abri-la agora?';

  @override
  String get actionOpenMobileDataSettings =>
      'Abrir as definições dos dados móveis';

  @override
  String get confirmMobileDataSettings =>
      'Abrir as definições dos dados móveis para verificar o roaming e os dados?';

  @override
  String get actionOpenPrivateDns => 'Abrir as definições do DNS privado';

  @override
  String get confirmPrivateDns =>
      'Abrir as definições do DNS privado para poder mudar para 1.1.1.1?';

  @override
  String mediumLabel(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'wifi': 'Wi-Fi',
      'mobile': 'dados móveis',
      'ethernet': 'ligação com fios',
      'vpn': 'ligação VPN',
      'other': 'ligação',
    });
    return '$_temp0';
  }

  @override
  String useCaseName(String id) {
    String _temp0 = intl.Intl.selectLogic(id, {
      'musicStreaming': 'streaming de música',
      'voiceCalls': 'chamadas de voz',
      'webBrowsing': 'navegação na web',
      'losslessMusic': 'música sem perdas',
      'videoCalls720': 'videochamadas (720p)',
      'teamGames': 'jogos em equipa',
      'videoCallsHd': 'videochamadas (HD)',
      'hdVideo': 'vídeo HD (1080p)',
      'fastGames': 'jogos online rápidos',
      'video4k': 'vídeo 4K',
      'other': 'esta atividade',
    });
    return '$_temp0';
  }

  @override
  String get useCaseNoneDemanding => 'qualquer coisa exigente';

  @override
  String listTwo(String a, String b) {
    return '$a e $b';
  }

  @override
  String listAnd(String head, String last) {
    return '$head e $last';
  }

  @override
  String shortfallDownload(String value) {
    return 'descarregamento $value Mbps';
  }

  @override
  String shortfallUpload(String value) {
    return 'envio $value Mbps';
  }

  @override
  String shortfallLatency(String value) {
    return 'latência $value ms';
  }

  @override
  String shortfallJitter(String value) {
    return 'jitter $value ms';
  }

  @override
  String shortfallLoss(String value) {
    return 'perda de pacotes $value%';
  }

  @override
  String get logHeadDeviceLink => 'Ligação do dispositivo';

  @override
  String get logHeadRouter => 'Router';

  @override
  String get logHeadInternetReachability => 'Acessibilidade da Internet';

  @override
  String get logHeadPorts => 'Portas';

  @override
  String get logHeadPopularSites => 'Sites populares';

  @override
  String get logHeadMeasurements => 'Medições';

  @override
  String get logHeadGoodFor => 'Bom para';

  @override
  String get logHeadNotGoodFor => 'Não suficiente para';

  @override
  String logHeadTestsPerformed(int count) {
    return 'Testes realizados ($count)';
  }

  @override
  String get logYes => 'sim';

  @override
  String get logNo => 'não';

  @override
  String get logUnknown => 'desconhecido';

  @override
  String get logNotApplicable => 'n/d';

  @override
  String get logNotMeasured => 'não medido';

  @override
  String get logNotReported => 'não reportado';

  @override
  String logConnectivity(String kind, String flight) {
    return 'Conetividade: $kind, modo de voo: $flight';
  }

  @override
  String get logFlightOn => 'ligado ✈️';

  @override
  String get logFlightOff => 'desligado ✅';

  @override
  String logGateway(String value) {
    return 'Gateway: $value';
  }

  @override
  String logGatewayReachable(String answer) {
    return 'Gateway acessível: $answer';
  }

  @override
  String logInternet(String state) {
    return 'Internet: $state';
  }

  @override
  String get logInternetReachableYes => 'acessível ✅';

  @override
  String get logInternetReachableNo => 'sem resposta ❌';

  @override
  String logCaptiveSignIn(String answer) {
    return 'Página de início de sessão cativa: $answer';
  }

  @override
  String logRawIpReachable(String answer) {
    return 'Endereço IP direto acessível: $answer';
  }

  @override
  String logNameResolves(String host, String answer) {
    return 'O nome resolve ($host): $answer';
  }

  @override
  String logRouteReached(String answer) {
    return 'A rota chegou à Internet: $answer';
  }

  @override
  String logRouteReachedHop(String answer, String hop) {
    return 'A rota chegou à Internet: $answer (último salto: $hop)';
  }

  @override
  String logPortLine(int port, String service, String state) {
    return 'Porta $port/$service: $state';
  }

  @override
  String get logPortOpen => 'aberta ✅';

  @override
  String get logPortBlocked => 'bloqueada ❌';

  @override
  String logPopularCountry(String value) {
    return 'País: $value';
  }

  @override
  String logPopularReachable(int reachable, int total, String mark) {
    return 'Sites populares acessíveis: $reachable/$total $mark';
  }

  @override
  String logTestedOver(String medium) {
    return 'Testado através de: $medium';
  }

  @override
  String get logMobileMeasuredReason =>
      'Os dados móveis foram medidos por serem a ligação em uso (Wi-Fi não ligado, ou optou por testar novamente pela rede móvel)';

  @override
  String logCellularSignalReported(int level) {
    return 'Sinal móvel: $level de 4';
  }

  @override
  String get logCellularSignalMissing => 'Sinal móvel: não reportado';

  @override
  String logDownloadLine(String value) {
    return 'Descarregamento: $value';
  }

  @override
  String logUploadLine(String value) {
    return 'Envio: $value';
  }

  @override
  String logMbps(String value) {
    return '$value Mbps';
  }

  @override
  String logSpeedTestMoved(String received, String sent) {
    return 'Movido pelo teste de velocidade: recebido $received, enviado $sent';
  }

  @override
  String get logLabelRouter => 'Router';

  @override
  String get logLabelInternet => 'Internet';

  @override
  String logLatencyNoReply(String label, int sent) {
    return 'Tempo de resposta de $label: sem resposta a $sent sondas';
  }

  @override
  String logLatencyLine(
    String label,
    int avg,
    int min,
    int max,
    String jitter,
    int loss,
    int received,
    int sent,
  ) {
    return 'Tempo de resposta de $label: $avg ms em média (mín $min, máx $max), jitter $jitter ms, perda $loss% ($received/$sent respostas)';
  }

  @override
  String logResponseWhileBusy(int ms) {
    return 'Tempo de resposta com a linha ocupada: $ms ms';
  }

  @override
  String logResponseWhileBusyRatio(int ms, String ratio) {
    return 'Tempo de resposta com a linha ocupada: $ms ms ($ratio× em repouso)';
  }

  @override
  String logNotGoodForItem(String name, String shortfalls) {
    return '$name — $shortfalls';
  }

  @override
  String logTestRecord(String test, String target, String traffic) {
    return '$test → $target$traffic';
  }

  @override
  String logTotalData(String traffic) {
    return 'Dados totais usados por este diagnóstico: $traffic';
  }

  @override
  String get logTotalCovers =>
      'Esse total cobre todos os testes acima, não apenas o teste de velocidade';

  @override
  String logTrafficSent(String size) {
    return 'enviado $size';
  }

  @override
  String logTrafficReceived(String size) {
    return 'recebido $size';
  }
}
