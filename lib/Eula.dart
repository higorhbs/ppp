import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:ppp/Screens/UserDOB.dart';
//import 'package:ppp/Screens/UserName.dart';
import 'package:ppp/util/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ppp/Screens/Welcome.dart';

class Eula extends StatefulWidget {
  @override
  _EulaState createState() => _EulaState();
}

class _EulaState extends State<Eula>  {

  bool value = false;

  //Text data = await getFileData('../asset/arquivos/eula.txt' );

  @override
  Widget build(BuildContext context) {
    
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0), // here the desired height
          child: AppBar(backgroundColor: Colors.transparent)),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 0),
                child: Container(
                  height: MediaQuery.of(context).size.height * .8,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 150,
                        ),
                        Text(
                           "ACCEPTANCE TERM".tr().toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 35,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal),
                        ),
                       
                        ListTile(
                          contentPadding: EdgeInsets.all(8),
                          subtitle: Text(
                                    getFileData(), style: TextStyle(fontSize: 16 ), textAlign: TextAlign.justify,
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, bottom: 0, top: 0),
                  child: Row (children: [
                            Checkbox(
                              value:value,
                              onChanged: (value) {
                                setState(() {
                                  this.value = value ;  
                                });
                              }, 
                              activeColor: Colors.purple,
                              //checkColor: Colors.white,
                              //fillColor: MaterialStateProperty.resolveWith(getColor),
                            ),
                            Text("I read and agree with the Term above".tr().toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold) ),
                  ],)
                ),       
              this.value 
                ?
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40, top: 50),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(25),
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      primaryColor.withOpacity(.5),
                                      primaryColor.withOpacity(.8),
                                      primaryColor,
                                      primaryColor
                                    ])),
                            height: MediaQuery.of(context).size.height * .065,
                            width: MediaQuery.of(context).size.width * .75,
                            child: Center(
                                child: Text(
                              "I ACCEPT".tr().toString(),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: textColor,
                                  fontWeight: FontWeight.bold),
                            ))),
                        onTap: () async {
                          await FirebaseAuth.instance.currentUser().then((_user) {
                            if (_user.displayName != null) {
                              if (_user.displayName.length > 0) {
                                  Navigator.push(
                                  context, CupertinoPageRoute(builder: (context) => Welcome()));
                              } else {
                                  Navigator.push(
                                  context, CupertinoPageRoute(builder: (context) => Welcome()));
                              }
                            } else {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => Welcome()));
                            }
                          });
                        },
                      ),
                    ),
                  )
                :
                  Padding(
                  padding: const EdgeInsets.only(bottom: 40, top: 50),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(25),
                              ),
                          height: MediaQuery.of(context).size.height * .065,
                          width: MediaQuery.of(context).size.width * .75,
                          child: Center(
                              child: Text(
                            "I ACCEPT".tr().toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: secondryColor,
                                    fontWeight: FontWeight.bold),
                              
                          ))),
                      onTap: () {},
                      
                    ),
                  ),
                )

            ],
          ),
        ));
  }

}

getFileData()  {

  
String texto  ;
String texto1 ;
String texto2 ;
String texto3 ;
String texto4 ;
String texto5 ;


texto = "CONTRATO DE LICENÇA PARA O USUÁRIO FINAL PPP\n\n" ;

texto += "Os termos deste Contrato de Licença de Usuário Final (“EULA” ou “Contrato”) regem o” “relacionamento entre Você e a PPP LTDA , referente ao uso do aplicativo distribuído pela” “PPP , o qual Você instalou, bem como todas e quaisquer atualizações do aplicativo , salvo” “atualizações que sejam acompanhadas por uma nova licença ,assim irá prevalecer a nova” ” licença." ;

texto += "As informações pessoais coletadas são regidas pela Política de Privacidade que se” “encontra on-line em https://cortexsolucoes.com.br/2021/08/11/termos-e-condicoes/” “(“Política de Privacidade”). ";

texto += "\n\nAO INSTALAR, USAR OU DE OUTRA FORMA ACESSAR O APLICATIVO, VOCÊ” “CONCORDA COM OS TERMOS DESTE EULA. CASO VOCÊ NÃO CONCORDE COM” “OS TERMOS DESTE EULA OU NÃO QUEIRA FICAR VINCULADO A ELES, NÃO” “INSTALE, USE OU DE OUTRA FORMA ACESSE O APLICATIVO. NO CASO DE UM” “CONFLITO ENTRE OS TERMOS DESTE EULA E QUAISQUER TERMOS ESPECIAIS,” “OS TERMOS DESTE EULA SEMPRE PREVALECERÃO.\n\n";

texto += "1. LICENÇA\n";
texto += "1.1 CONCESSÃO DE LICENÇA LIMITADA\n";
texto += "Ao comprar ou usar o Aplicativo, Você está adquirindo, e a PPP lhe concede, uma licença” “pessoal, revogável, limitada, não exclusiva, não sublicenciável e intransferível para instalar” “e usar o Aplicativo para Seu uso pessoal e não comercial, sujeito às limitações definidas” “neste EULA. O Aplicativo está sendo licenciado a Você, e Você reconhece que nenhum” “título ou propriedade do Aplicativo está sendo transferido ou atribuído a Você e que este” “EULA não deve ser considerado uma venda de quaisquer direitos sobre o Aplicativo. Seus” “direitos aqui concedidos estão sujeitos ao Seu cumprimento deste EULA, e Você concorda” “em não usar o Aplicativo para nenhum outro fim. Qualquer uso comercial é proibido.";

texto += "\n\n1.2 LIMITAÇÕES DE LICENÇA";
texto += "\nQualquer uso do Aplicativo em violação destas Limitações de Licença é estritamente” “proibido e pode resultar na revogação imediata de Sua Licença Limitada e em Você ser” “responsabilizado por violações da lei.";

texto += "\n\nA menos que Você tenha recebido autorização prévia por escrito da PPP, Você concorda” “em não:";

texto += "\nusar fraudes, software de automação, bots, hacks ou qualquer outro software não” “autorizado, criado para modificar ou interferir no Aplicativo e/ou quaisquer arquivos que” “façam parte do Aplicativo;";
texto += "\nacessar ou usar o Aplicativo por meio de qualquer tecnologia ou meio que não sejam os” “fornecidos no Aplicativo,ou de outros meios explicitamente autorizados que a PPP venha a” “designar;";
texto += "\nusar o Aplicativo ou recursos relacionados e/ou marcas registradas da PPP em, ou em” “conexão com, conteúdo que (i) promova fraudes, hacks, violência, discriminação, temas” “impróprios, atividades ilegais ou conteúdo sexualmente explícito; (ii) faça declarações” “falsas, desonestas, depreciativas ou difamatórias sobre a PPP e/ou seus produtos,” “funcionários e representantes; e/ou (iii) contenha outros tipos de conteúdo censurável;" ;
texto += "\nrevender, copiar, transferir, distribuir, exibir, traduzir, modificar o Aplicativo ou criar obras” “derivadas do Aplicativo ou qualquer parte dele; " ;
texto += "\nusar o Aplicativo quando estiver operando veículos";
texto += "\nremover ou alterar as marcas comerciais ou logotipos da PPP ou " ;
texto += "\navisos legais incluídos no Aplicativo ou ativos relacionados" ;
texto += "\nusar o serviço para tentar obter acesso não autorizado a quaisquer serviços, dados contas ou redes";
texto += "\npublicar qualquer informação que contenha nudez, violência ou assuntos ofensivos ou que” “contenha um link para esse tipo de conteúdo;";
texto += "\ntentar ou praticar qualquer tipo de abuso, ameaça, difamação ou, de outra forma, infringir” “ou violar os direitos de qualquer outra parte;";
texto += "\nusar o Aplicativo de qualquer forma ilegal, fraudulenta ou enganosa;";
texto += "\nusar tecnologia ou quaisquer outros meios para acessar informações proprietárias da PPP” “que não forem autorizadas pela PPP;";
texto += "\nusar ou executar qualquer sistema automatizado para acessar o site ou os sistemas de” “computador da PPP;";
texto += "\ntentar introduzir vírus ou qualquer outro código de computador malicioso que interrompa,” “destrua ou limite a funcionalidade de qualquer software de computador, hardware ou” “equipamento de telecomunicações;";
texto += "\ntentar obter acesso não autorizado à rede de computadores ou a contas de usuários da” “PPP;";
texto += "\nincentivar conduta que constitua delito criminal ou resulte em responsabilidade civil; ou";
texto += "\nusar o Aplicativo de qualquer maneira não permitida expressamente neste EULA.";
texto += "\n\nA PPP se reserva o direito de determinar, a seu critério exclusivo, que tipo de conduta é” “considerada uma violação dos termos deste EULA. Além disso, a PPP se reserva o direito” “de tomar as medidas devidas em resultado de Sua violação dos termos deste EULA,” “incluindo, entre outros, proibi-lo de usar o Aplicativo da PPP, integral ou parcialmente.";

texto += "\n\n1.3 USOS ADMISSÍVEIS DO APLICATIVO";
texto += "\nO USO DO APLICATIVO E DE SUAS INFORMAÇÕES TRANSMITIDAS EM CONEXÃO” “COM O APLICATIVO É LIMITADO À FUNCIONALIDADE DO APLICATIVO E À” “CONCESSÃO DE LICENÇA LIMITADA,CONFORME DESCRITO ACIMA. SENDO ASSIM,” “VOCÊ NÃO PODE USAR O APLICATIVO OU QUALQUER UM DE SEUS” “COMPONENTES, EXCETO QUANDO EXPRESSAMENTE AUTORIZADO, POR” “ESCRITO E COM ANTECEDÊNCIA, PELA PPP.";

texto += "\n\n2. ACESSO E DOWNLOAD DO APLICATIVO NA APPLE APP STORE";
texto += "O seguinte se aplica a qualquer Aplicativo que for acessado ou baixado na App Store” “(“Aplicativo Obtido na App Store”):";

texto += "\nVocê reconhece e concorda que este EULA é firmado apenas entre Você e a PPP, e não” “com a Apple; e que a PPP, não a Apple, é a única responsável pelo Aplicativo Obtido na” “App Store e por seu conteúdo. Seu uso do Aplicativo Obtido na App Store deve estar em” “conformidade com os Termos de Serviço da App Store.";
texto += "\nVocê só usará o Aplicativo Obtido na App Store (i) em um produto da marca Apple, cujo” “sistema operacional seja o iOS (sistema operacional exclusivo da Apple); e (ii) conforme” “permitido pelas “Regras de Uso” estabelecidas nos Termos de Serviço da Apple App” “Store.";
texto += "\nVocê reconhece que a Apple não  é  obrigada  a  fornecer  nenhum  serviço de” “manutenção ou suporte referente ao Aplicativo Obtido na App Store.";
texto += "\nCaso qualquer Aplicativo Obtido na App Store não esteja em conformidade com a garantia” “aplicável, Você poderá notificar a Apple, e a Apple lhe reembolsará o valor da compra do” “Aplicativo Obtido na App Store e, dentro dos limites permitidos por lei, a Apple não terá” “nenhuma outra obrigação de garantia referente ao Aplicativo Obtido na App Store. Entre a” “PPP e a Apple, quaisquer outros danos, reivindicações, perdas, responsabilidades, custos” “ou despesas atribuíveis à não conformidade de qualquer garantia serão responsabilidade “exclusiva da PPP.";
texto += "\nSem limitar quaisquer outros termos deste EULA, Você deve cumprir todos os termos do” “acordo de terceiros aplicáveis ao usar o Aplicativo Obtido na App Store.";

texto += "\n\n3 ENVIOS DE CONTEÚDO DO USUÁRIO";
texto += "\nO Aplicativo pode permitir que Você crie conteúdo, como vídeos, dados, fotografias,” “mensagens, textos e outras informações (“Conteúdo do Usuário”) e compartilhe esse” “Conteúdo do Usuário com a PPP ou com outros sites.";
texto += "\nVocê concorda em não compartilhar Conteúdo do Usuário que: (i) possa criar um risco de” “prejuízo, perda, dano físico ou mental, sofrimento emocional, morte, deficiência,” “desfiguração ou doença física ou mental a Você, a qualquer outra pessoa ou a qualquer” “animal; (ii) possa criar um risco de qualquer outra perda ou dano a qualquer pessoa ou” “propriedade; \n(iii) tente prejudicar ou explorar crianças expondo-as a um conteúdo” “inadequado, solicitando a elas detalhes de identificação pessoal ou de qualquer outra” “forma; (iv) possa constituir ou contribuir para um crime ou ato ilícito; \n(v) contenha qualquer” “informação ou conteúdo que a PPP considere ilegal, prejudicial, abusivo, racial ou” “etnicamente ofensivo, difamatório,violador, invasivo da privacidade pessoal ou dos direitos” “de publicidade, assediante, humilhante a outras pessoas (publicamente ou de qualquer” “outra forma), calunioso, ameaçador, profano ou de outra forma censurável;\n (vi) contenha” “qualquer informação ou conteúdo que seja ilegal (incluindo, entre outros, a divulgação de” “informações privilegiadas de acordo com as leis de valores mobiliários ou de segredos” “comerciais de qualquer outra parte); \n(vii) contenha qualquer informação ou conteúdo que” “Você não tenha o direito de disponibilizar de acordo com quaisquer leis ou relações” “contratuais ou fiduciárias; ou (viii) contenha quaisquer informações ou conteúdos que Você” “saiba que não estão corretos e atuais.";
texto += "Salvo qualquer outra disposição expressa neste documento, a PPP se reserva o direito, a” “seu critério exclusivo, de examinar, monitorar, proibir, editar, excluir ou de outra forma” “tornar indisponível qualquer Conteúdo do Usuário a qualquer momento, sem aviso prévio,” “por qualquer motivo ou sem motivo algum. \nAo aceitar este EULA, Você concede Seu” “consentimento irrevogável a esse monitoramento e reconhece e concorda que Você não” “tem nenhuma expectativa de privacidade sobre o compartilhamento de Seu Conteúdo do” “Usuário. Se a PPP em qualquer momento decidir, a seu critério exclusivo, monitorar o” “Conteúdo do Usuário, a PPP não assume nenhuma responsabilidade pelo Conteúdo do” “Usuário e/ou nenhuma obrigação de remover ou editar qualquer Conteúdo do Usuário que” “for impróprio.";

texto += "\n\nA CRIAÇÃO E O COMPARTILHAMENTO DO CONTEÚDO DO USUÁRIO, CONFORME” “DESCRITO NESTA SEÇÃO, NÃO SÃO PERMITIDOS PARA USUÁRIOS QUE SE” “IDENTIFICAREM COMO MENORES QUE A IDADE DE CONSENTIMENTO DIGITAL. ";

texto += "\n\n3.1 LIMITAÇÃO DE RESPONSABILIDADE PARA O CONTEÚDO DO USUÁRIO";
texto += "A PPP não é a responsável, nem poderá ser responsabilizada, por qualquer Conteúdo do” “Usuário que Você ou qualquer outro usuário ou terceiro crie com o Aplicativo ou” “compartilhe por meio do Aplicativo. \nVocê será o único responsável por seu Conteúdo do” “Usuário e pelas consequências do compartilhamento ou da publicação dele. \nVocê” “compreende e concorda que quaisquer perdas ou danos de qualquer tipo que ocorram” “como resultado do uso de qualquer Conteúdo do Usuário que Você venha a enviar, fazer” “upload, download ou streaming, publicar, transmitir, exibir, compartilhar ou de outra forma” “disponibilizar ou acessar por meio de seu uso do Aplicativo são de Sua exclusiva” “responsabilidade. \nCom  relação  a  Seu  Conteúdo  do Usuário  e  em complemento a” “quaisquer outras representações e garantias contidas neste EULA, Você afirma, declara e” “garante o seguinte:";

texto += "\n\n1. A PPP não é responsável por qualquer exibição em público ou pelo mau uso do seu” “Conteúdo do Usuário. Você  compreende  e  reconhece  que  pode  ser exposto a” “Conteúdo do Usuário que seja impreciso, ofensivo, indecente, censurável ou inadequado” “para crianças e concorda que a PPP não será responsabilizada por quaisquer danos com” “os quais Você alegue que terá de arcar em decorrência desse Conteúdo do Usuário.";

texto += "\n\n2. ACESSO";
texto += "\nVocê deve fornecer, por conta própria, os equipamentos, as conexões à Internet ou os dispositivos móveis e/ou os planos de serviço necessários para acessar e usar o Aplicativo. A PPP não garante que o Aplicativo esteja disponível em todas as localizações geográficas."; 
texto += "\nVocê reconhece que,ao usar o Aplicativo, Sua operadora sem fio pode cobrar" ;
texto += "\ntaxas referentes a dados, mensagens e/ou qualquer outro acesso sem fio. Consulte Sua operadora para saber se há taxas que se aplicam a Você. Você é o único responsável por quaisquer custos incorridos ao acessar o Aplicativo em Seu dispositivo móvel e/ou computador pessoal. Seu direito de usar o Aplicativo também se baseia em Sua conformidade com quaisquer termos aplicáveis do acordo firmado entre Você e terceiros ao usar o Aplicativo.";

texto += "\n\n3. COMPRAS NO APLICATIVO  As Compras no Aplicativo podem ser feitas simplesmente inserindo Sua senha da loja de aplicativos e Você é o ;responsável por manter a segurança dessa senha. Sua autenticação e manutenção de segurança estão sujeitas aos termos específicos da loja de aplicativos e do sistema operacional ('OS') de Seu dispositivo móvel. Você deve estar ciente de que, ao baixar um Aplicativo, após um intervalo de 15 minutos no iOS e de 30 minutos no Android, as Compras no Aplicativo podem ser feitas sendo a inserção de uma senha da loja de aplicativos. Você também deve levar em consideração que a versão OS 2.1 ou versões mais antigas de telefones Android não exigem a inserção da senha usada em uma conta da loja de aplicativos para realizar Compras no Aplicativo.";

texto += "\n\nAo fazer uma assinatura, Você concorda que Sua assinatura será renovada” “automaticamente e que, a menos que Você cancele Sua assinatura, Você nos autoriza a” “cobrar de Sua conta pelo prazo de renovação.Os valores do período de renovação” “automática e do preço da assinatura serão os mesmos cobrados inicialmente, a menos” “que seja divulgado de outra forma para Você no momento da venda. Você pode gerenciar” “Suas assinaturas nas configurações de Sua conta na loja de aplicativos. \nVocê deve estar” “ciente de que a exclusão do Aplicativo de Seu dispositivo nem sempre resulta no” “cancelamento de Sua assinatura. " ;

texto += "\n\nTODAS AS COMPRAS SÃO DEFINITIVAS. VOCÊ RECONHECE QUE A PPP NÃO É” “OBRIGADA A FORNECER UM REEMBOLSO POR QUALQUER MOTIVO, E QUE VOCÊ” “NÃO RECEBERÁ DINHEIRO OU OUTRA COMPENSAÇÃO POR ASSINATURAS/ITENS” “VIRTUAIS QUE NÃO FOREM USADOS QUANDO UMA CONTA FOR FECHADA,” “INDEPENDENTEMENTE SE ESSE FECHAMENTO FOI VOLUNTÁRIO OU” “INVOLUNTÁRIO, A NÃO SER QUE SEJA EXIGIDO POR LEI." ;
texto += "\n\nRENÚNCIA AO DIREITO DE ANULAÇÃO DE COMPRA" ;
texto += "Você reconhece que, ao clicar no botão “COMPRAR” ou em qualquer botão semelhante,” “para fazer uma Compra no Aplicativo, a PPP fornece a Você acesso e execução imediatos” “do conteúdo digital, sem ter de esperar os 14 dias de anulação de compra. Por meio deste” “documento, Você concorda e reconhece expressamente que renuncia Seu direito de” “anulação dessa compra." ;

texto += "\n\n4. PRAZO E RESCISÃO" ;
texto += "\nO prazo deste EULA terá início na data em que Você instalar ou de outra forma usar o” “Aplicativo e terminará na data em que Você descartar o Aplicativo ou a PPP rescindir este” “EULA, o que ocorrer primeiro. Você poderá rescindir este EULA desinstalando o” “Aplicativo." ;

texto += "\n\nDesinstalar o Aplicativo não resulta na restituição do valor pago pelo Aplicativo. A PPP se” “reserva o direito, a seu critério exclusivo, de rescindir este EULA, ou solicitar que Você” “remova o Aplicativo de seu dispositivo por qualquer motivo, incluindo, entre outros, uma” “conclusão razoável por parte da PPP de que Você tenha violado este EULA. Quando da” “rescisão, Você deverá cessar imediatamente  qualquer  uso  do    Aplicativo e destruir” “todas as cópias do Aplicativo que estejam em Sua posse ou sob Seu controle." ;

texto += "\n\A rescisão não limitará nenhum dos outros direitos ou recursos jurídicos ou de equidade da PPP. Se uma das plataformas desativar a capacidade de usar o Aplicativo em Seu dispositivo de acordo com o Contrato entre Você e essa plataforma, quaisquer direitos de licença associados à PPP também serão rescindidos." ;

texto += "\n\n5. RESERVA DE DIREITOS";
texto += "Você obteve uma licença para o Aplicativo, e Seus direitos estão sujeitos a este EULA.” “Exceto conforme  expressamente  licenciado para Você neste documento, a PPP se” “reserva todos os direitos, títulos e interesses no Aplicativo. Esta licença está limitada aos” “direitos de propriedade intelectual da PPP e não inclui quaisquer direitos a outras patentes” “ou propriedade intelectual." ;

texto += "\n\nA PPP retém todos os direitos, títulos e interesses em relação aos Direitos de Propriedade” “Intelectual da PPP, conforme definido abaixo, estejam registrados ou não, e todos os” “Aplicativos que os compõem, com exceção dos direitos autorais de tecnologias de” “terceiros. O software da PPP é protegido pelas leis e tratados aplicáveis em todo o mundo." ;

texto += "\n\nPara os fins deste EULA, “Direitos de Propriedade Intelectual” significa todos os direitos de” “patentes, marcas registradas, direitos de propriedade, direitos autorais, títulos, códigos de” “computador, efeitos audiovisuais, temas, personagens, nomes de personagens, histórias,” “diálogos, cenários, arte, efeitos sonoros, obras musicais, direitos de layout de circuito” “(“mask work”), direitos morais, direitos de publicidade, marca comercial, direitos de” “conjunto-imagem e marca de serviço, reputação, direitos de segredo comercial e outros” “direitos de propriedade intelectual, conforme possam existir atualmente ou vir a existir de” “agora em diante, e portanto todos os Aplicativos e os respectivos registros, renovações e” “extensões, de acordo com as leis de qualquer estado, país, território ou outra jurisdição." ;

texto += "\n\n7. CONTEÚDO DE TERCEIROS" ;
texto += "\n\n7.1 TECNOLOGIA DE TERCEIROS";
texto += "\nUm ou todos os Aplicativos usam tecnologias de terceiros, ao passo que essas “tecnologias de terceiros podem estar sujeitas a licenças comerciais (“Tecnologia Comercial” “de Terceiros”) ou a licenças de software de código-fonte aberto (Componentes de Código-Fonte Aberto).";

texto += "\n\n7.2 TECNOLOGIA DE EXIBIÇÃO DE PUBLICIDADE DE TERCEIROS" ;
texto += "\nO Aplicativo pode incorporar tecnologias dinâmicas de exibição de publicidade durante o” “seu uso, que permitem que anúncios sejam temporariamente carregados no Aplicativo em” “Seu dispositivo móvel e/ou computador pessoal e substituídos enquanto Você estiver” “on-line. ";

texto += "\n\n8. ISENÇÃO DE GARANTIAS";
texto += "NA MEDIDA MÁXIMA QUE FOR PERMITIDA PELA LEGISLAÇÃO APLICÁVEL, O” “APLICATIVO É FORNECIDO A VOCÊ “NO ESTADO EM QUE SE ENCONTRA”, COM” “TODAS AS FALHAS, SEM GARANTIA DE QUALQUER NATUREZA, SEM” “CERTIFICAÇÕES DE DESEMPENHO OU COMPROMISSOS DE QUALQUER” “NATUREZA, E VOCÊ O USA POR SUA CONTA E RISCO. VOCÊ ASSUME O RISCO” “TOTAL QUANTO À QUALIDADE E AO DESEMPENHO SEREM SATISFATÓRIOS. ";

texto += "\n\nA PPP NÃO GARANTE CONTRA INTERFERÊNCIA EM SEU APROVEITAMENTO DO” “APLICATIVO; QUE O APLICATIVO ATENDERÁ ÀS SUAS NECESSIDADES; QUE A” “OPERAÇÃO DO APLICATIVO SERÁ ININTERRUPTA OU LIVRE DE ERROS; QUE O” “APLICATIVO INTEROPERARÁ OU SERÁ COMPATÍVEL COM QUALQUER OUTRO” “APLICATIVO; QUE QUAISQUER ERROS NO APLICATIVO SERÃO CORRIGIDOS; OU” “QUE O APLICATIVO ESTARÁ DISPONÍVEL PARA REINSTALAÇÕES NO MESMO OU” “EM VÁRIOS DISPOSITIVOS.";

texto += "\n\nNENHUMA INFORMAÇÃO OU CONSELHO, ORAL OU POR ESCRITO, FORNECIDO” “PELA PPP OU QUALQUER REPRESENTANTE OU TERCEIROS AUTORIZADOS” “CRIARÁ UMA  GARANTIA.  ALGUMAS   JURISDIÇÕES    NÃO PERMITEM A” “EXCLUSÃO OU LIMITAÇÃO DAS GARANTIAS IMPLÍCITAS OU A LIMITAÇÃO DOS” “DIREITOS LEGAIS APLICÁVEIS DE UM CONSUMIDOR, PORTANTO, ALGUMAS OU” “TODAS AS EXCLUSÕES E LIMITAÇÕES ACIMA PODEM NÃO SE APLICAR A VOCÊ.";

texto += "\n\n10. LIMITAÇÃO DE RESPONSABILIDADE";
texto += "\nNA MEDIDA MÁXIMA QUE FOR PERMITIDA PELA LEGISLAÇÃO APLICÁVEL, EM” “HIPÓTESE NENHUMA A PPP, SUAS SUBSIDIÁRIAS OU AFILIADAS E” “LICENCIADORAS PODERÃO SER RESPONSABILIZADAS PERANTE VOCÊ POR” \n“QUAISQUER DANOS PESSOAIS OU MATERIAIS, \nLUCROS CESSANTES, \nCUSTO DE” “BENS OU SERVIÇOS SUBSTITUTOS, \nPERDA DE DADOS, \nPERDA DE REPUTAÇÃO,” “\nPARALISAÇÃO NO TRABALHO, \nFALHA OU MAU FUNCIONAMENTO DO” \n“DISPOSITIVO OU QUALQUER OUTRA FORMA DE DANOS DIRETOS, INDIRETOS,” \n“ESPECIAIS, INCIDENTAIS, EMERGENTES OU PUNITIVOS EM QUAISQUER” \n“CONDIÇÕES DE AÇÃO DECORRENTES OU RELACIONADAS A ESTE EULA OU AO” \n“APLICATIVO, QUER DECORRENTES DE ATO ILÍCITO (INCLUSIVE NEGLIGÊNCIA),” \n“CONTRATO, RESPONSABILIDADE OBJETIVA OU QUALQUER OUTRO,” \n“INDEPENDENTEMENTE DE A PPP TER SIDO INFORMADA SOBRE A POSSIBILIDADE” \n“DESSES DANOS E INDEPENDENTEMENTE DE O REPARO, SUBSTITUIÇÃO OU” \n“REEMBOLSO DO APLICATIVO (CASO CONCEDIDOS A NOSSO EXCLUSIVO” \n“CRITÉRIO) NÃO COMPENSAR VOCÊ PLENAMENTE POR QUAISQUER PERDAS.";

texto += "\n\nALGUMAS JURISDIÇÕES NÃO PERMITEM UMA LIMITAÇÃO DA RESPONSABILIDADE” “POR MORTE, DANOS PESSOAIS, DECLARAÇÕES FALSAS E FRAUDULENTAS OU” “DETERMINADOS ATOS INTENCIONAIS OU NEGLIGENTES, OU A VIOLAÇÃO DE LEIS” “ESPECÍFICAS, OU A LIMITAÇÃO DE DANOS INCIDENTAIS OU EMERGENTES,” “PORTANTO, ALGUMAS OU TODAS AS LIMITAÇÕES DE RESPONSABILIDADE ACIMA” “PODEM NÃO SE APLICAR A VOCÊ. Em hipótese nenhuma, as obrigações totais da PPP” “perante Você por todos os danos (exceto conforme exigido pela legislação aplicável)” “excederão o valor efetivamente pago por Você pelo Aplicativo. ESTA LIMITAÇÃO SE” “APLICA, MAS NÃO SE LIMITA, A QUALQUER FATOR RELACIONADO AO APLICATIVO,” “SERVIÇOS OU CONTEÚDO DISPONIBILIZADO POR MEIO DO APLICATIVO. Você” “concorda que as disposições deste EULA que limitam a responsabilização são termos” “essenciais deste EULA.";

texto += "\n\n11. INDENIZAÇÃO";
texto += "\nVocê concorda em defender, indenizar e isentar a PPP e seus empregados, prestadores” “de serviços, administradores e diretores de todas e quaisquer reivindicações, processos,” “danos, custos, ações, multas, penalidades, responsabilizações, despesas (inclusive” “honorários advocatícios) decorrentes de Seu uso ou mau uso do Aplicativo, violação do” ‘EULA ou violação de quaisquer direitos de terceiros.";

texto += "\n\n12. DISPOSIÇÕES FINAIS";
texto += "\n12.1 ELEGIBILIDADE";
texto += "Qualquer pessoa que usa o Aplicativo declara à PPP que tem, no mínimo, a idade da” “maioridade sob a lei aplicável, ou, caso não tenha a idade da maioridade, que é um menor” “emancipado ou possui o consentimento legal de um pai ou responsável e é plenamente” “competente e apto para cumprir os termos, condições, obrigações, afirmações,” “declarações e garantias estabelecidos neste Contrato, e para cumprir e obedecer este” “Contrato.";

texto += "\n\n12.2 DIVISIBILIDADE E SOBREVIVÊNCIA";
texto += "\nCaso qualquer disposição deste EULA seja ilegal ou inexequível de acordo com a” “legislação aplicável, o restante da disposição deverá ser reparado para alcançar efeito o” “mais próximo possível do termo original, e todas as outras disposições deste EULA” “continuarão em pleno vigor e efeito.";

texto += "\n\n12.3 ACORDO INTEGRAL";
texto += "Este Contrato constitui o acordo integral entre Você e a PPP em relação ao Aplicativo e” “suplanta todos os entendimentos anteriores ou contemporâneos referentes a esse” “assunto. Nenhuma reparação ou modificação deste EULA será vinculativa, a menos que” “efetuada por escrito e assinada pela PPP. Nenhuma falha ou atraso, por parte de qualquer” “uma das partes, em exercer qualquer direito ou poder previsto neste documento impede o” “exercício de qualquer outro direito aqui previsto. No caso de um conflito entre este EULA e” “qualquer compra aplicável ou outros termos, os termos deste EULA prevalecerão.";

texto += "\n\n12.4 ALTERAÇÕES" ;
texto += "\nAtualizaremos ocasionalmente deste EULA conforme for necessário para proteger nossos usuários, fornecer informações atualizadas e responder a mudanças legais e técnicas. Nós nos reservamos o direito de alterar este EULA a qualquer momento. Seu uso do Aplicativo depois que as alterações forem integradas constituirá Sua aceitação das alterações.";

return texto ;

}



