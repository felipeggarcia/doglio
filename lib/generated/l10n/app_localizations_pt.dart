// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Doglio';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get save => 'Salvar';

  @override
  String get delete => 'Excluir';

  @override
  String get edit => 'Editar';

  @override
  String get close => 'Fechar';

  @override
  String get back => 'Voltar';

  @override
  String get next => 'Próximo';

  @override
  String get previous => 'Anterior';

  @override
  String get loading => 'Carregando...';

  @override
  String get error => 'Erro';

  @override
  String get success => 'Sucesso';

  @override
  String get retry => 'Tentar Novamente';

  @override
  String get search => 'Buscar';

  @override
  String get filter => 'Filtrar';

  @override
  String get clearFilters => 'Limpar Filtros';

  @override
  String get noResults => 'Nenhum resultado encontrado';

  @override
  String get tryAgain => 'Tente novamente';

  @override
  String get signIn => 'Entrar';

  @override
  String get signUp => 'Cadastrar';

  @override
  String get signOut => 'Sair';

  @override
  String get login => 'Login';

  @override
  String get register => 'Registrar';

  @override
  String get forgotPassword => 'Esqueceu a senha?';

  @override
  String get forgotPasswordSubtitle =>
      'Digite seu endereço de e-mail e enviaremos um link para redefinir sua senha';

  @override
  String get resetPassword => 'Redefinir Senha';

  @override
  String get sendResetLink => 'Enviar Link de Redefinição';

  @override
  String get sendingResetEmail => 'Enviando e-mail de redefinição...';

  @override
  String get resendEmail => 'Reenviar E-mail';

  @override
  String get resendingEmail => 'Reenviando e-mail...';

  @override
  String get passwordResetEmailSent =>
      'E-mail de redefinição de senha enviado com sucesso!';

  @override
  String get emailResent => 'E-mail de redefinição reenviado!';

  @override
  String get emailResendFailed => 'Falha ao reenviar e-mail. Tente novamente';

  @override
  String get rememberPassword => 'Lembra sua senha?';

  @override
  String get emailSent => 'E-mail Enviado!';

  @override
  String get passwordResetLinkSent =>
      'Enviamos um link de redefinição de senha para:';

  @override
  String get checkEmailInstructions =>
      'Verifique seu e-mail e clique no link para redefinir sua senha. O link expirará em 1 hora';

  @override
  String get backToSignIn => 'Voltar para Login';

  @override
  String get welcomeBack => 'Bem-vindo de Volta!';

  @override
  String get loginSuccess => 'Login realizado com sucesso!';

  @override
  String get loginSubtitle => 'Entre para acessar sua conta';

  @override
  String get registerSubtitle => 'Crie sua conta para começar a comprar';

  @override
  String get joinDoglio => 'Junte-se ao Doglio';

  @override
  String get createAccount => 'Criar Conta';

  @override
  String get email => 'E-mail';

  @override
  String get emailHint => 'Digite seu endereço de e-mail';

  @override
  String get password => 'Senha';

  @override
  String get passwordHint => 'Digite sua senha';

  @override
  String get confirmPassword => 'Confirmar Senha';

  @override
  String get confirmPasswordHint => 'Confirme sua senha';

  @override
  String get fullName => 'Nome Completo';

  @override
  String get fullNameHint => 'Digite seu nome completo';

  @override
  String get createPassword => 'Crie uma senha forte';

  @override
  String get createPasswordHint => 'Crie uma senha forte';

  @override
  String get signingIn => 'Entrando...';

  @override
  String get orSignInWith => 'Ou entre com';

  @override
  String get orRegisterWith => 'Ou cadastre-se com';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta?';

  @override
  String get dontHaveAccount => 'Não tem uma conta?';

  @override
  String get termsOfService => 'Termos de Serviço';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String fieldRequired(String field) {
    return '$field é obrigatório';
  }

  @override
  String get emailRequired => 'E-mail é obrigatório';

  @override
  String get emailInvalid => 'Por favor, digite um endereço de e-mail válido';

  @override
  String get passwordRequired => 'Senha é obrigatória';

  @override
  String passwordTooShort(int minLength) {
    return 'A senha deve ter pelo menos $minLength caracteres';
  }

  @override
  String get passwordMustHaveUppercase =>
      'A senha deve conter pelo menos uma letra maiúscula';

  @override
  String get passwordMustHaveLowercase =>
      'A senha deve conter pelo menos uma letra minúscula';

  @override
  String get passwordMustHaveNumber =>
      'A senha deve conter pelo menos um número';

  @override
  String get confirmPasswordRequired => 'Por favor, confirme sua senha';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem';

  @override
  String get nameRequired => 'Nome é obrigatório';

  @override
  String get nameInvalidCharacters => 'O nome contém caracteres inválidos';

  @override
  String nameTooShort(Object minLength) {
    return 'O nome deve ter pelo menos $minLength caracteres';
  }

  @override
  String nameTooLong(Object maxLength) {
    return 'O nome não deve exceder $maxLength caracteres';
  }

  @override
  String get phoneRequired => 'Número de telefone é obrigatório';

  @override
  String get phoneInvalid => 'Por favor, digite um número de telefone válido';

  @override
  String get priceRequired => 'Preço é obrigatório';

  @override
  String get priceInvalid => 'Por favor, digite um preço válido';

  @override
  String get priceMustBePositive => 'O preço deve ser positivo';

  @override
  String get pricePositive => 'O preço deve ser positivo';

  @override
  String get priceTooHigh => 'O preço é muito alto';

  @override
  String get quantityRequired => 'Quantidade é obrigatória';

  @override
  String get quantityInvalid => 'Por favor, digite uma quantidade válida';

  @override
  String get quantityMustBePositive => 'A quantidade deve ser positiva';

  @override
  String get quantityPositive => 'A quantidade deve ser positiva';

  @override
  String get quantityTooHigh => 'A quantidade é muito alta';

  @override
  String get descriptionRequired => 'Descrição é obrigatória';

  @override
  String descriptionTooShort(int minLength) {
    return 'A descrição deve ter pelo menos $minLength caracteres';
  }

  @override
  String descriptionTooLong(int maxLength) {
    return 'A descrição deve ter no máximo $maxLength caracteres';
  }

  @override
  String get cardNumberRequired => 'Número do cartão é obrigatório';

  @override
  String get cardNumberInvalid =>
      'Por favor, digite um número de cartão válido';

  @override
  String get cvvRequired => 'CVV é obrigatório';

  @override
  String get cvvInvalid => 'Por favor, digite um CVV válido';

  @override
  String get expiryDateRequired => 'Data de validade é obrigatória';

  @override
  String get cardExpired => 'O cartão expirou';

  @override
  String get pleaseAcceptTerms => 'Por favor, aceite os termos e condições';

  @override
  String get invalidCredentials => 'E-mail ou senha inválidos';

  @override
  String get userNotFound => 'Usuário não encontrado';

  @override
  String get emailAlreadyInUse => 'E-mail já está em uso';

  @override
  String get weakPassword => 'A senha é muito fraca';

  @override
  String get networkError => 'Erro de rede. Verifique sua conexão';

  @override
  String get accountInactive => 'Conta está inativa';

  @override
  String get unknownError => 'Ocorreu um erro desconhecido';

  @override
  String get loginFailed => 'Falha no login';

  @override
  String get registrationFailed => 'Falha no cadastro';

  @override
  String get validationFailed => 'Falha na validação';

  @override
  String get passwordResetFailed => 'Falha ao redefinir senha';

  @override
  String get updateFailed => 'Falha na atualização';

  @override
  String get deleteFailed => 'Falha ao excluir';

  @override
  String get store => 'Loja';

  @override
  String get products => 'Produtos';

  @override
  String get categories => 'Categorias';

  @override
  String get featured => 'Destaque';

  @override
  String get featuredProducts => 'Produtos em Destaque';

  @override
  String get viewAll => 'Ver todos';

  @override
  String get addToCart => 'Adicionar ao Carrinho';

  @override
  String get cart => 'Carrinho';

  @override
  String get checkout => 'Finalizar Compra';

  @override
  String get myOrders => 'Meus Pedidos';

  @override
  String get searchProducts => 'Buscar produtos...';

  @override
  String get noCategoriesAvailable => 'Nenhuma categoria disponível';

  @override
  String get noProductsAvailable => 'Nenhum produto disponível';

  @override
  String get noProductsFound => 'Nenhum produto encontrado';

  @override
  String get outOfStock => 'Fora de Estoque';

  @override
  String get inStock => 'Em Estoque';

  @override
  String get unavailable => 'Indisponível';

  @override
  String stockCount(int count) {
    return '$count em estoque';
  }

  @override
  String get productDetails => 'Detalhes do Produto';

  @override
  String get description => 'Descrição';

  @override
  String get noDescriptionAvailable => 'Nenhuma descrição disponível';

  @override
  String get price => 'Preço';

  @override
  String get quantity => 'Quantidade';

  @override
  String get total => 'Total';

  @override
  String get home => 'Início';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Configurações';

  @override
  String get about => 'Sobre';

  @override
  String get help => 'Ajuda';

  @override
  String get contact => 'Contato';

  @override
  String get currency => 'R\$';

  @override
  String get currencySymbol => 'R\$';

  @override
  String get monthJan => 'Jan';

  @override
  String get monthFeb => 'Fev';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Abr';

  @override
  String get monthMay => 'Mai';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Ago';

  @override
  String get monthSep => 'Set';

  @override
  String get monthOct => 'Out';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dez';

  @override
  String get myAccount => 'Minha Conta';

  @override
  String drawerWelcome(String name) {
    return 'Bem-vindo, $name!';
  }

  @override
  String get myFavorites => 'Meus Favoritos';

  @override
  String get myAddresses => 'Meus Endereços';

  @override
  String get favorites => 'Favoritos';

  @override
  String get noFavorites => 'Você ainda não tem favoritos';

  @override
  String get addToFavorites => 'Adicionar aos favoritos';

  @override
  String get removeFromFavorites => 'Remover dos favoritos';

  @override
  String get favoriteAdded => 'Adicionado aos favoritos';

  @override
  String get favoriteRemoved => 'Removido dos favoritos';

  @override
  String get orders => 'Pedidos';

  @override
  String get noOrders => 'Você ainda não fez nenhum pedido';

  @override
  String get orderDetails => 'Detalhes do Pedido';

  @override
  String get orderDate => 'Data';

  @override
  String get orderTotal => 'Total do pedido';

  @override
  String get orderHistory => 'Histórico';

  @override
  String get orderItems => 'Itens';

  @override
  String get orderStatusPending => 'Pendente';

  @override
  String get orderStatusProcessing => 'Em processamento';

  @override
  String get orderStatusShipped => 'Enviado';

  @override
  String get orderStatusDelivered => 'Entregue';

  @override
  String get orderStatusCancelled => 'Cancelado';

  @override
  String get paymentInfo => 'Pagamento';

  @override
  String get deliveryInfo => 'Entrega';

  @override
  String get deliveryPickup => 'Retirada na loja';

  @override
  String get deliveryHome => 'Entrega em domicílio';

  @override
  String get addresses => 'Endereços';

  @override
  String get noAddresses => 'Nenhum endereço cadastrado';

  @override
  String get addAddress => 'Adicionar endereço';

  @override
  String get editAddress => 'Editar endereço';

  @override
  String get deleteAddress => 'Excluir endereço';

  @override
  String get primaryAddress => 'Principal';

  @override
  String get setPrimaryAddress => 'Definir como principal';

  @override
  String get addressLabel => 'Identificação (ex: Casa, Trabalho)';

  @override
  String get addressStreet => 'Rua / Avenida';

  @override
  String get addressNumber => 'Número';

  @override
  String get addressComplement => 'Complemento (opcional)';

  @override
  String get addressCity => 'Cidade';

  @override
  String get addressState => 'Estado';

  @override
  String get addressZip => 'CEP';

  @override
  String get addressSaved => 'Endereço salvo com sucesso';

  @override
  String get addressDeleted => 'Endereço excluído';

  @override
  String get addressDistrict => 'Bairro';

  @override
  String get newAddressTitle => 'Novo Endereço';

  @override
  String get editAddressTitle => 'Editar Endereço';

  @override
  String get confirmDeleteAddressMessage =>
      'Tem certeza que deseja excluir este endereço?';

  @override
  String zipCodeLabel(String zip) {
    return 'CEP: $zip';
  }

  @override
  String get requiredField => 'Obrigatório';

  @override
  String get shippingAddress => 'Endereço de entrega';

  @override
  String get orderStatusTitle => 'Status';

  @override
  String trackingCodeLabel(String code) {
    return 'Código de rastreio: $code';
  }

  @override
  String orderNumber(String id) {
    return 'Pedido #$id';
  }

  @override
  String get favoriteUpdateError =>
      'Erro ao atualizar favoritos. Tente novamente.';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appName => 'Doglio';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get save => 'Salvar';

  @override
  String get delete => 'Excluir';

  @override
  String get edit => 'Editar';

  @override
  String get close => 'Fechar';

  @override
  String get back => 'Voltar';

  @override
  String get next => 'Próximo';

  @override
  String get previous => 'Anterior';

  @override
  String get loading => 'Carregando...';

  @override
  String get error => 'Erro';

  @override
  String get success => 'Sucesso';

  @override
  String get retry => 'Tentar Novamente';

  @override
  String get search => 'Buscar';

  @override
  String get filter => 'Filtrar';

  @override
  String get clearFilters => 'Limpar Filtros';

  @override
  String get noResults => 'Nenhum resultado encontrado';

  @override
  String get tryAgain => 'Tente novamente';

  @override
  String get signIn => 'Entrar';

  @override
  String get signUp => 'Cadastrar';

  @override
  String get signOut => 'Sair';

  @override
  String get login => 'Login';

  @override
  String get register => 'Registrar';

  @override
  String get forgotPassword => 'Esqueceu a senha?';

  @override
  String get forgotPasswordSubtitle =>
      'Digite seu endereço de e-mail e enviaremos um link para redefinir sua senha';

  @override
  String get resetPassword => 'Redefinir Senha';

  @override
  String get sendResetLink => 'Enviar Link de Redefinição';

  @override
  String get sendingResetEmail => 'Enviando e-mail de redefinição...';

  @override
  String get resendEmail => 'Reenviar E-mail';

  @override
  String get resendingEmail => 'Reenviando e-mail...';

  @override
  String get passwordResetEmailSent =>
      'E-mail de redefinição de senha enviado com sucesso!';

  @override
  String get emailResent => 'E-mail de redefinição reenviado!';

  @override
  String get emailResendFailed => 'Falha ao reenviar e-mail. Tente novamente';

  @override
  String get rememberPassword => 'Lembra sua senha?';

  @override
  String get emailSent => 'E-mail Enviado!';

  @override
  String get passwordResetLinkSent =>
      'Enviamos um link de redefinição de senha para:';

  @override
  String get checkEmailInstructions =>
      'Verifique seu e-mail e clique no link para redefinir sua senha. O link expirará em 1 hora';

  @override
  String get backToSignIn => 'Voltar para Login';

  @override
  String get welcomeBack => 'Bem-vindo de Volta!';

  @override
  String get loginSuccess => 'Login realizado com sucesso!';

  @override
  String get loginSubtitle => 'Entre para acessar sua conta';

  @override
  String get registerSubtitle => 'Crie sua conta para começar a comprar';

  @override
  String get joinDoglio => 'Junte-se ao Doglio';

  @override
  String get createAccount => 'Criar Conta';

  @override
  String get email => 'E-mail';

  @override
  String get emailHint => 'Digite seu endereço de e-mail';

  @override
  String get password => 'Senha';

  @override
  String get passwordHint => 'Digite sua senha';

  @override
  String get confirmPassword => 'Confirmar Senha';

  @override
  String get confirmPasswordHint => 'Confirme sua senha';

  @override
  String get fullName => 'Nome Completo';

  @override
  String get fullNameHint => 'Digite seu nome completo';

  @override
  String get createPassword => 'Crie uma senha forte';

  @override
  String get createPasswordHint => 'Crie uma senha forte';

  @override
  String get signingIn => 'Entrando...';

  @override
  String get orSignInWith => 'Ou entre com';

  @override
  String get orRegisterWith => 'Ou cadastre-se com';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta?';

  @override
  String get dontHaveAccount => 'Não tem uma conta?';

  @override
  String get termsOfService => 'Termos de Serviço';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String fieldRequired(String field) {
    return '$field é obrigatório';
  }

  @override
  String get emailRequired => 'E-mail é obrigatório';

  @override
  String get emailInvalid => 'Por favor, digite um endereço de e-mail válido';

  @override
  String get passwordRequired => 'Senha é obrigatória';

  @override
  String passwordTooShort(int minLength) {
    return 'A senha deve ter pelo menos $minLength caracteres';
  }

  @override
  String get passwordMustHaveUppercase =>
      'A senha deve conter pelo menos uma letra maiúscula';

  @override
  String get passwordMustHaveLowercase =>
      'A senha deve conter pelo menos uma letra minúscula';

  @override
  String get passwordMustHaveNumber =>
      'A senha deve conter pelo menos um número';

  @override
  String get confirmPasswordRequired => 'Por favor, confirme sua senha';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem';

  @override
  String get nameRequired => 'Nome é obrigatório';

  @override
  String get nameInvalidCharacters => 'O nome contém caracteres inválidos';

  @override
  String nameTooShort(Object minLength) {
    return 'O nome deve ter pelo menos $minLength caracteres';
  }

  @override
  String nameTooLong(Object maxLength) {
    return 'O nome não deve exceder $maxLength caracteres';
  }

  @override
  String get phoneRequired => 'Número de telefone é obrigatório';

  @override
  String get phoneInvalid => 'Por favor, digite um número de telefone válido';

  @override
  String get priceRequired => 'Preço é obrigatório';

  @override
  String get priceInvalid => 'Por favor, digite um preço válido';

  @override
  String get priceMustBePositive => 'O preço deve ser positivo';

  @override
  String get pricePositive => 'O preço deve ser positivo';

  @override
  String get priceTooHigh => 'O preço é muito alto';

  @override
  String get quantityRequired => 'Quantidade é obrigatória';

  @override
  String get quantityInvalid => 'Por favor, digite uma quantidade válida';

  @override
  String get quantityMustBePositive => 'A quantidade deve ser positiva';

  @override
  String get quantityPositive => 'A quantidade deve ser positiva';

  @override
  String get quantityTooHigh => 'A quantidade é muito alta';

  @override
  String get descriptionRequired => 'Descrição é obrigatória';

  @override
  String descriptionTooShort(int minLength) {
    return 'A descrição deve ter pelo menos $minLength caracteres';
  }

  @override
  String descriptionTooLong(int maxLength) {
    return 'A descrição deve ter no máximo $maxLength caracteres';
  }

  @override
  String get cardNumberRequired => 'Número do cartão é obrigatório';

  @override
  String get cardNumberInvalid =>
      'Por favor, digite um número de cartão válido';

  @override
  String get cvvRequired => 'CVV é obrigatório';

  @override
  String get cvvInvalid => 'Por favor, digite um CVV válido';

  @override
  String get expiryDateRequired => 'Data de validade é obrigatória';

  @override
  String get cardExpired => 'O cartão expirou';

  @override
  String get pleaseAcceptTerms => 'Por favor, aceite os termos e condições';

  @override
  String get invalidCredentials => 'E-mail ou senha inválidos';

  @override
  String get userNotFound => 'Usuário não encontrado';

  @override
  String get emailAlreadyInUse => 'E-mail já está em uso';

  @override
  String get weakPassword => 'A senha é muito fraca';

  @override
  String get networkError => 'Erro de rede. Verifique sua conexão';

  @override
  String get accountInactive => 'Conta está inativa';

  @override
  String get unknownError => 'Ocorreu um erro desconhecido';

  @override
  String get loginFailed => 'Falha no login';

  @override
  String get registrationFailed => 'Falha no cadastro';

  @override
  String get validationFailed => 'Falha na validação';

  @override
  String get passwordResetFailed => 'Falha ao redefinir senha';

  @override
  String get updateFailed => 'Falha na atualização';

  @override
  String get deleteFailed => 'Falha ao excluir';

  @override
  String get store => 'Loja';

  @override
  String get products => 'Produtos';

  @override
  String get categories => 'Categorias';

  @override
  String get featured => 'Destaque';

  @override
  String get featuredProducts => 'Produtos em Destaque';

  @override
  String get viewAll => 'Ver todos';

  @override
  String get addToCart => 'Adicionar ao Carrinho';

  @override
  String get cart => 'Carrinho';

  @override
  String get checkout => 'Finalizar Compra';

  @override
  String get myOrders => 'Meus Pedidos';

  @override
  String get searchProducts => 'Buscar produtos...';

  @override
  String get noCategoriesAvailable => 'Nenhuma categoria disponível';

  @override
  String get noProductsAvailable => 'Nenhum produto disponível';

  @override
  String get noProductsFound => 'Nenhum produto encontrado';

  @override
  String get outOfStock => 'Fora de Estoque';

  @override
  String get inStock => 'Em Estoque';

  @override
  String get unavailable => 'Indisponível';

  @override
  String stockCount(int count) {
    return '$count em estoque';
  }

  @override
  String get productDetails => 'Detalhes do Produto';

  @override
  String get description => 'Descrição';

  @override
  String get noDescriptionAvailable => 'Nenhuma descrição disponível';

  @override
  String get price => 'Preço';

  @override
  String get quantity => 'Quantidade';

  @override
  String get total => 'Total';

  @override
  String get home => 'Início';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Configurações';

  @override
  String get about => 'Sobre';

  @override
  String get help => 'Ajuda';

  @override
  String get contact => 'Contato';

  @override
  String get currency => 'R\$';

  @override
  String get currencySymbol => 'R\$';

  @override
  String get monthJan => 'Jan';

  @override
  String get monthFeb => 'Fev';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Abr';

  @override
  String get monthMay => 'Mai';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Ago';

  @override
  String get monthSep => 'Set';

  @override
  String get monthOct => 'Out';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dez';

  @override
  String get myAccount => 'Minha Conta';

  @override
  String drawerWelcome(String name) {
    return 'Bem-vindo, $name!';
  }

  @override
  String get myFavorites => 'Meus Favoritos';

  @override
  String get myAddresses => 'Meus Endereços';

  @override
  String get favorites => 'Favoritos';

  @override
  String get noFavorites => 'Você ainda não tem favoritos';

  @override
  String get addToFavorites => 'Adicionar aos favoritos';

  @override
  String get removeFromFavorites => 'Remover dos favoritos';

  @override
  String get favoriteAdded => 'Adicionado aos favoritos';

  @override
  String get favoriteRemoved => 'Removido dos favoritos';

  @override
  String get orders => 'Pedidos';

  @override
  String get noOrders => 'Você ainda não fez nenhum pedido';

  @override
  String get orderDetails => 'Detalhes do Pedido';

  @override
  String get orderDate => 'Data';

  @override
  String get orderTotal => 'Total do pedido';

  @override
  String get orderHistory => 'Histórico';

  @override
  String get orderItems => 'Itens';

  @override
  String get orderStatusPending => 'Pendente';

  @override
  String get orderStatusProcessing => 'Em processamento';

  @override
  String get orderStatusShipped => 'Enviado';

  @override
  String get orderStatusDelivered => 'Entregue';

  @override
  String get orderStatusCancelled => 'Cancelado';

  @override
  String get paymentInfo => 'Pagamento';

  @override
  String get deliveryInfo => 'Entrega';

  @override
  String get deliveryPickup => 'Retirada na loja';

  @override
  String get deliveryHome => 'Entrega em domicílio';

  @override
  String get addresses => 'Endereços';

  @override
  String get noAddresses => 'Nenhum endereço cadastrado';

  @override
  String get addAddress => 'Adicionar endereço';

  @override
  String get editAddress => 'Editar endereço';

  @override
  String get deleteAddress => 'Excluir endereço';

  @override
  String get primaryAddress => 'Principal';

  @override
  String get setPrimaryAddress => 'Definir como principal';

  @override
  String get addressLabel => 'Identificação (ex: Casa, Trabalho)';

  @override
  String get addressStreet => 'Rua / Avenida';

  @override
  String get addressNumber => 'Número';

  @override
  String get addressComplement => 'Complemento (opcional)';

  @override
  String get addressCity => 'Cidade';

  @override
  String get addressState => 'Estado';

  @override
  String get addressZip => 'CEP';

  @override
  String get addressSaved => 'Endereço salvo com sucesso';

  @override
  String get addressDeleted => 'Endereço excluído';

  @override
  String get addressDistrict => 'Bairro';

  @override
  String get newAddressTitle => 'Novo Endereço';

  @override
  String get editAddressTitle => 'Editar Endereço';

  @override
  String get confirmDeleteAddressMessage =>
      'Tem certeza que deseja excluir este endereço?';

  @override
  String zipCodeLabel(String zip) {
    return 'CEP: $zip';
  }

  @override
  String get requiredField => 'Obrigatório';

  @override
  String get shippingAddress => 'Endereço de entrega';

  @override
  String get orderStatusTitle => 'Status';

  @override
  String trackingCodeLabel(String code) {
    return 'Código de rastreio: $code';
  }

  @override
  String orderNumber(String id) {
    return 'Pedido #$id';
  }

  @override
  String get favoriteUpdateError =>
      'Erro ao atualizar favoritos. Tente novamente.';
}
