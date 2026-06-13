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
  String get adminPanel => 'Painel Administrativo';

  @override
  String get adminPanelSubtitle => 'Ferramenta de gestão';

  @override
  String adminGreeting(String name) {
    return 'Olá, $name';
  }

  @override
  String get adminUsers => 'Usuários';

  @override
  String get adminProducts => 'Produtos';

  @override
  String get adminOrders => 'Pedidos';

  @override
  String get adminCategories => 'Categorias';

  @override
  String get adminPromotions => 'Promoções';

  @override
  String get adminUnderConstruction => 'Em construção';

  @override
  String get adminUnderConstructionDesc =>
      'Esta seção estará disponível em breve.';

  @override
  String get logoutConfirmation => 'Tem certeza que deseja sair?';

  @override
  String get adminUsersSearchHint => 'Buscar por nome ou email';

  @override
  String get adminFilterRole => 'Função';

  @override
  String get adminFilterStatus => 'Status';

  @override
  String get adminFilterAll => 'Todos';

  @override
  String get adminRoleAdmin => 'Admin';

  @override
  String get adminRoleCustomer => 'Cliente';

  @override
  String get adminStatusActive => 'Ativo';

  @override
  String get adminStatusInactive => 'Inativo';

  @override
  String get adminUsersEmpty => 'Nenhum usuário encontrado';

  @override
  String get adminLoadMore => 'Carregar mais';

  @override
  String get adminUserNew => 'Novo usuário';

  @override
  String get adminUserCreateTitle => 'Novo usuário';

  @override
  String get adminUserEditTitle => 'Editar usuário';

  @override
  String get adminFieldRole => 'Função';

  @override
  String get adminFieldActive => 'Ativo';

  @override
  String get adminFieldCity => 'Cidade';

  @override
  String get adminFieldState => 'Estado';

  @override
  String get adminFieldCpfCnpj => 'CPF/CNPJ';

  @override
  String get adminFieldBirthDate => 'Nascimento';

  @override
  String get adminUserCreated => 'Usuário criado.';

  @override
  String get adminUserSaved => 'Usuário atualizado.';

  @override
  String get adminUserDeleted => 'Usuário removido.';

  @override
  String get adminUserDeleteConfirm => 'Remover este usuário?';

  @override
  String get adminCategoryNew => 'Nova categoria';

  @override
  String get adminCategoryCreateTitle => 'Nova categoria';

  @override
  String get adminCategoryEditTitle => 'Editar categoria';

  @override
  String get adminCategoriesSearchHint => 'Buscar por nome';

  @override
  String get adminCategoriesEmpty => 'Nenhuma categoria encontrada';

  @override
  String get adminCategoryNoneSelected => 'Nenhuma selecionada';

  @override
  String get adminCategoryCreated => 'Categoria criada.';

  @override
  String get adminCategorySaved => 'Categoria atualizada.';

  @override
  String get adminCategoryDeleted => 'Categoria removida.';

  @override
  String get adminCategoryDeleteConfirm => 'Remover esta categoria?';

  @override
  String get adminFieldName => 'Nome';

  @override
  String get adminFieldHighlighted => 'Destaque';

  @override
  String adminCategoryProductsCount(int count) {
    return '$count produtos';
  }

  @override
  String get adminProductNew => 'Novo produto';

  @override
  String get adminProductCreateTitle => 'Novo produto';

  @override
  String get adminProductEditTitle => 'Editar produto';

  @override
  String get adminProductsSearchHint => 'Buscar por nome';

  @override
  String get adminProductsEmpty => 'Nenhum produto encontrado';

  @override
  String adminProductStockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count em estoque',
      one: '1 em estoque',
      zero: 'Sem estoque',
    );
    return '$_temp0';
  }

  @override
  String get adminProductFilterHighlighted => 'Destaque';

  @override
  String get adminProductFilterOutOfStock => 'Sem estoque';

  @override
  String get adminProductFiltersButton => 'Filtros';

  @override
  String get adminProductFiltersTitle => 'Filtros';

  @override
  String get adminProductFilterCategories => 'Categorias';

  @override
  String get adminProductFilterPriceMin => 'Preço mínimo';

  @override
  String get adminProductFilterPriceMax => 'Preço máximo';

  @override
  String get adminProductFilterDateFrom => 'Data inicial';

  @override
  String get adminProductFilterDateTo => 'Data final';

  @override
  String get adminProductSortBy => 'Ordenar por';

  @override
  String get adminProductSortName => 'Nome';

  @override
  String get adminProductSortPrice => 'Preço';

  @override
  String get adminProductSortStock => 'Estoque';

  @override
  String get adminProductSortCreated => 'Data de criação';

  @override
  String get adminProductSortUpdated => 'Data de atualização';

  @override
  String get adminProductSortAsc => 'Crescente';

  @override
  String get adminProductSortDesc => 'Decrescente';

  @override
  String get adminProductFiltersApply => 'Aplicar';

  @override
  String get adminProductFiltersClear => 'Limpar';

  @override
  String get adminFieldDescription => 'Descrição';

  @override
  String get adminFieldPrice => 'Preço';

  @override
  String get adminFieldCategories => 'Categorias';

  @override
  String get adminProductImages => 'Imagens';

  @override
  String get adminProductAddImages => 'Adicionar';

  @override
  String adminProductImageLimit(int max) {
    return 'Máximo de $max imagens por produto.';
  }

  @override
  String get adminProductCreated => 'Produto criado.';

  @override
  String get adminProductSaved => 'Produto atualizado.';

  @override
  String get adminProductDeleted => 'Produto removido.';

  @override
  String get adminProductDeleteConfirm => 'Remover este produto?';

  @override
  String get adminProductStockSection => 'Estoque';

  @override
  String get adminProductStockManage => 'Gerenciar estoque';

  @override
  String get adminProductStockHistory => 'Histórico de estoque';

  @override
  String get adminProductStockCurrent => 'Estoque atual';

  @override
  String get adminProductStockEmpty => 'Nenhuma movimentação de estoque';

  @override
  String get adminProductStockMove => 'Movimentar estoque';

  @override
  String get adminProductStockModeDelta => 'Entrada/Saída';

  @override
  String get adminProductStockModeAbsolute => 'Definir total';

  @override
  String get adminProductStockTypeIn => 'Entrada';

  @override
  String get adminProductStockTypeOut => 'Saída';

  @override
  String get adminProductStockQuantityField => 'Quantidade';

  @override
  String get adminProductStockQuantityInvalid =>
      'Informe uma quantidade válida';

  @override
  String get adminProductStockReason => 'Motivo';

  @override
  String get adminProductReasonPurchase => 'Compra';

  @override
  String get adminProductReasonReturn => 'Devolução';

  @override
  String get adminProductReasonManual => 'Ajuste manual';

  @override
  String get adminProductReasonLoss => 'Perda';

  @override
  String get adminProductStockNotes => 'Observações';

  @override
  String adminProductStockBeforeAfter(int before, int after) {
    return '$before → $after';
  }

  @override
  String get adminProductStockSaved => 'Estoque atualizado.';

  @override
  String get adminOrdersTitle => 'Pedidos';

  @override
  String get adminOrdersEmpty => 'Nenhum pedido encontrado';

  @override
  String get adminOrdersSearchHint => 'Buscar por nº do pedido';

  @override
  String get adminOrdersFiltersButton => 'Filtros';

  @override
  String get adminOrdersFiltersTitle => 'Filtros de pedidos';

  @override
  String get adminOrdersFiltersDeliveryType => 'Tipo de entrega';

  @override
  String get adminOrdersFilterAll => 'Todos';

  @override
  String get adminOrdersFilterDelivery => 'Entrega';

  @override
  String get adminOrdersFilterPickup => 'Retirada';

  @override
  String get adminOrdersFilterPeriod => 'Período';

  @override
  String get adminOrderStatusPending => 'Pendente';

  @override
  String get adminOrderStatusConfirmed => 'Confirmado';

  @override
  String get adminOrderStatusPreparing => 'Preparando';

  @override
  String get adminOrderStatusOutForDelivery => 'Em entrega';

  @override
  String get adminOrderStatusDelivered => 'Entregue';

  @override
  String get adminOrderStatusCancelled => 'Cancelado';

  @override
  String adminOrderDetailTitle(String number) {
    return 'Pedido #$number';
  }

  @override
  String get adminOrderCustomerSection => 'Cliente';

  @override
  String get adminOrderItemsSection => 'Itens do pedido';

  @override
  String get adminOrderPaymentSection => 'Pagamento';

  @override
  String get adminOrderHistorySection => 'Histórico de status';

  @override
  String get adminOrderDeliverySection => 'Entrega';

  @override
  String get adminOrderSubtotal => 'Subtotal';

  @override
  String get adminOrderDiscount => 'Desconto';

  @override
  String get adminOrderTotal => 'Total';

  @override
  String get adminOrderPickupLabel => 'Retirada no local';

  @override
  String get adminOrderDeliveryLabel => 'Entrega';

  @override
  String get adminOrderPaymentPending => 'Pendente';

  @override
  String get adminOrderPaymentPaid => 'Pago';

  @override
  String get adminOrderPaymentApproved => 'Aprovado';

  @override
  String get adminOrderPixCode => 'Código PIX';

  @override
  String adminOrderPixExpires(String date) {
    return 'Expira em $date';
  }

  @override
  String get adminOrderUpdateStatus => 'Atualizar status';

  @override
  String get adminOrderStatusNotes => 'Observações (opcional)';

  @override
  String get adminOrderStatusUpdated => 'Status atualizado.';

  @override
  String get adminOrderStatusUpdateError => 'Erro ao atualizar status.';

  @override
  String get adminOrderConfirm => 'Confirmar pedido';

  @override
  String get adminOrderStartPreparing => 'Iniciar preparo';

  @override
  String get adminOrderSendOut => 'Saiu para entrega';

  @override
  String get adminOrderMarkDelivered => 'Marcar como entregue';

  @override
  String get adminOrderCancel => 'Cancelar pedido';

  @override
  String get adminOrderAddItem => 'Adicionar produto';

  @override
  String get adminOrderEditItem => 'Editar item';

  @override
  String get adminOrderRemoveItem => 'Remover item';

  @override
  String get adminOrderRemoveItemConfirm => 'Remover este item do pedido?';

  @override
  String get adminOrderItemSaved => 'Item atualizado.';

  @override
  String get adminOrderItemAdded => 'Produto adicionado.';

  @override
  String get adminOrderItemRemoved => 'Item removido.';

  @override
  String get adminOrderSearchProduct => 'Buscar produto...';

  @override
  String get adminPromotionNew => 'Nova promoção';

  @override
  String get adminPromotionCreateTitle => 'Nova promoção';

  @override
  String get adminPromotionEditTitle => 'Editar promoção';

  @override
  String get adminPromotionsSearchHint => 'Buscar promoção';

  @override
  String get adminPromotionsEmpty => 'Nenhuma promoção encontrada';

  @override
  String get adminPromotionTypeLabel => 'Tipo de desconto';

  @override
  String get adminPromotionTypePercentage => 'Percentual (%)';

  @override
  String get adminPromotionTypeFixed => 'Valor fixo (R\$)';

  @override
  String get adminPromotionDiscountValue => 'Valor do desconto';

  @override
  String get adminPromotionStartsAt => 'Início';

  @override
  String get adminPromotionEndsAt => 'Término (opcional)';

  @override
  String get adminPromotionMinQuantity => 'Qtd. mínima';

  @override
  String get adminPromotionLinkedProducts => 'Produtos vinculados';

  @override
  String get adminPromotionAddProduct => 'Adicionar produto';

  @override
  String get adminPromotionUseLimit => 'Limite de usos';

  @override
  String adminPromotionUsesCount(int count) {
    return 'Usos: $count';
  }

  @override
  String get adminPromotionCreated => 'Promoção criada.';

  @override
  String get adminPromotionSaved => 'Promoção salva.';

  @override
  String get adminPromotionDeleted => 'Promoção removida.';

  @override
  String get adminPromotionDeleteConfirm => 'Remover esta promoção?';

  @override
  String get adminPromotionFilterActive => 'Ativas';

  @override
  String get adminPromotionFilterExpired => 'Expiradas';

  @override
  String get adminProductTabData => 'Dados';

  @override
  String get adminProductTabPromotions => 'Promoções';

  @override
  String get adminProductPromotionsEmpty => 'Nenhuma promoção vinculada';

  @override
  String get adminPromotionUseLimitHint => 'Sem limite';

  @override
  String get adminPromotionLinkButton => 'Vincular';

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
  String get loadMore => 'Carregar mais';

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
  String get deliveryHome => 'Receber em casa';

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

  @override
  String get cartEmpty => 'Seu carrinho está vazio';

  @override
  String get cartEmptySubtitle => 'Adicione produtos para continuar comprando';

  @override
  String get clearCart => 'Limpar carrinho';

  @override
  String get clearCartConfirm => 'Deseja remover todos os itens do carrinho?';

  @override
  String get cartCleared => 'Carrinho limpo';

  @override
  String get cartItemAdded => 'Adicionado ao carrinho';

  @override
  String get continueShopping => 'Continuar comprando';

  @override
  String get stockWarning => 'Alguns itens têm problemas de estoque';

  @override
  String get priceChanged => 'Preços de alguns itens foram alterados';

  @override
  String get checkoutTitle => 'Resumo do Pedido';

  @override
  String get checkoutDeliverySection => 'Como receber?';

  @override
  String get checkoutSelectAddress => 'Endereço de entrega';

  @override
  String get checkoutAddNewAddress => 'Cadastrar novo endereço';

  @override
  String get checkoutPayWithPix => 'Pagar com PIX';

  @override
  String checkoutPayWithMethod(String name) {
    return 'Pagar com $name';
  }

  @override
  String get checkoutPaymentMethod => 'Forma de pagamento';

  @override
  String get checkoutSelectPaymentMethod => 'Selecione como quer pagar';

  @override
  String get checkoutNoPaymentMethods => 'Nenhum método disponível';

  @override
  String get checkoutShippingFee => 'Frete';

  @override
  String get checkoutFreeShipping => 'Retirada gratuita';

  @override
  String get checkoutCepLabel => 'CEP de entrega';

  @override
  String get checkoutCepFound => 'Endereço encontrado!';

  @override
  String get checkoutCepNotFound => 'CEP não encontrado nos seus endereços';

  @override
  String get checkoutSaveAddress => 'Salvar endereço?';

  @override
  String get checkoutSaveAddressMessage =>
      'Deseja salvar este endereço na sua conta e torná-lo favorito?';

  @override
  String get checkoutUpdateAddress => 'Atualizar endereço salvo?';

  @override
  String get checkoutUpdateAddressMessage =>
      'Os dados foram alterados. Deseja atualizar o endereço salvo?';

  @override
  String get checkoutPlacing => 'Finalizando pedido...';

  @override
  String get checkoutValidating => 'Validando carrinho...';

  @override
  String get checkoutError => 'Erro ao finalizar pedido';

  @override
  String get checkoutCartChanged =>
      'Carrinho atualizado — revise os itens antes de continuar';

  @override
  String get pixTitle => 'Pagamento PIX';

  @override
  String get pixCopyCode => 'Copiar código';

  @override
  String get pixCopied => 'Código copiado!';

  @override
  String get pixExpiresIn => 'Expira em 30 minutos';

  @override
  String get pixSuccessTitle => 'Pedido criado!';

  @override
  String get pixSuccessSubtitle =>
      'Efetue o pagamento PIX para confirmar seu pedido';

  @override
  String get pixInstructions =>
      'Abra o app do seu banco, entre em Pix e cole o código abaixo';

  @override
  String get pixCodeLabel => 'Código PIX';

  @override
  String get orderSeeDetails => 'Ver detalhes completos';

  @override
  String get orderStatusHistory => 'Histórico de status';

  @override
  String get checkoutSavedAddresses => 'Endereços salvos';

  @override
  String get checkoutUseNewAddress => 'Usar outro endereço';

  @override
  String get checkoutDeliveryToSelected => 'Entrega para este endereço';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appName => 'Doglio';

  @override
  String get adminPanel => 'Painel Administrativo';

  @override
  String get adminPanelSubtitle => 'Ferramenta de gestão';

  @override
  String adminGreeting(String name) {
    return 'Olá, $name';
  }

  @override
  String get adminUsers => 'Usuários';

  @override
  String get adminProducts => 'Produtos';

  @override
  String get adminOrders => 'Pedidos';

  @override
  String get adminCategories => 'Categorias';

  @override
  String get adminPromotions => 'Promoções';

  @override
  String get adminUnderConstruction => 'Em construção';

  @override
  String get adminUnderConstructionDesc =>
      'Esta seção estará disponível em breve.';

  @override
  String get logoutConfirmation => 'Tem certeza que deseja sair?';

  @override
  String get adminUsersSearchHint => 'Buscar por nome ou email';

  @override
  String get adminFilterRole => 'Função';

  @override
  String get adminFilterStatus => 'Status';

  @override
  String get adminFilterAll => 'Todos';

  @override
  String get adminRoleAdmin => 'Admin';

  @override
  String get adminRoleCustomer => 'Cliente';

  @override
  String get adminStatusActive => 'Ativo';

  @override
  String get adminStatusInactive => 'Inativo';

  @override
  String get adminUsersEmpty => 'Nenhum usuário encontrado';

  @override
  String get adminLoadMore => 'Carregar mais';

  @override
  String get adminUserNew => 'Novo usuário';

  @override
  String get adminUserCreateTitle => 'Novo usuário';

  @override
  String get adminUserEditTitle => 'Editar usuário';

  @override
  String get adminFieldRole => 'Função';

  @override
  String get adminFieldActive => 'Ativo';

  @override
  String get adminFieldCity => 'Cidade';

  @override
  String get adminFieldState => 'Estado';

  @override
  String get adminFieldCpfCnpj => 'CPF/CNPJ';

  @override
  String get adminFieldBirthDate => 'Nascimento';

  @override
  String get adminUserCreated => 'Usuário criado.';

  @override
  String get adminUserSaved => 'Usuário atualizado.';

  @override
  String get adminUserDeleted => 'Usuário removido.';

  @override
  String get adminUserDeleteConfirm => 'Remover este usuário?';

  @override
  String get adminCategoryNew => 'Nova categoria';

  @override
  String get adminCategoryCreateTitle => 'Nova categoria';

  @override
  String get adminCategoryEditTitle => 'Editar categoria';

  @override
  String get adminCategoriesSearchHint => 'Buscar por nome';

  @override
  String get adminCategoriesEmpty => 'Nenhuma categoria encontrada';

  @override
  String get adminCategoryNoneSelected => 'Nenhuma selecionada';

  @override
  String get adminCategoryCreated => 'Categoria criada.';

  @override
  String get adminCategorySaved => 'Categoria atualizada.';

  @override
  String get adminCategoryDeleted => 'Categoria removida.';

  @override
  String get adminCategoryDeleteConfirm => 'Remover esta categoria?';

  @override
  String get adminFieldName => 'Nome';

  @override
  String get adminFieldHighlighted => 'Destaque';

  @override
  String adminCategoryProductsCount(int count) {
    return '$count produtos';
  }

  @override
  String get adminProductNew => 'Novo produto';

  @override
  String get adminProductCreateTitle => 'Novo produto';

  @override
  String get adminProductEditTitle => 'Editar produto';

  @override
  String get adminProductsSearchHint => 'Buscar por nome';

  @override
  String get adminProductsEmpty => 'Nenhum produto encontrado';

  @override
  String adminProductStockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count em estoque',
      one: '1 em estoque',
      zero: 'Sem estoque',
    );
    return '$_temp0';
  }

  @override
  String get adminProductFilterHighlighted => 'Destaque';

  @override
  String get adminProductFilterOutOfStock => 'Sem estoque';

  @override
  String get adminProductFiltersButton => 'Filtros';

  @override
  String get adminProductFiltersTitle => 'Filtros';

  @override
  String get adminProductFilterCategories => 'Categorias';

  @override
  String get adminProductFilterPriceMin => 'Preço mínimo';

  @override
  String get adminProductFilterPriceMax => 'Preço máximo';

  @override
  String get adminProductFilterDateFrom => 'Data inicial';

  @override
  String get adminProductFilterDateTo => 'Data final';

  @override
  String get adminProductSortBy => 'Ordenar por';

  @override
  String get adminProductSortName => 'Nome';

  @override
  String get adminProductSortPrice => 'Preço';

  @override
  String get adminProductSortStock => 'Estoque';

  @override
  String get adminProductSortCreated => 'Data de criação';

  @override
  String get adminProductSortUpdated => 'Data de atualização';

  @override
  String get adminProductSortAsc => 'Crescente';

  @override
  String get adminProductSortDesc => 'Decrescente';

  @override
  String get adminProductFiltersApply => 'Aplicar';

  @override
  String get adminProductFiltersClear => 'Limpar';

  @override
  String get adminFieldDescription => 'Descrição';

  @override
  String get adminFieldPrice => 'Preço';

  @override
  String get adminFieldCategories => 'Categorias';

  @override
  String get adminProductImages => 'Imagens';

  @override
  String get adminProductAddImages => 'Adicionar';

  @override
  String adminProductImageLimit(int max) {
    return 'Máximo de $max imagens por produto.';
  }

  @override
  String get adminProductCreated => 'Produto criado.';

  @override
  String get adminProductSaved => 'Produto atualizado.';

  @override
  String get adminProductDeleted => 'Produto removido.';

  @override
  String get adminProductDeleteConfirm => 'Remover este produto?';

  @override
  String get adminProductStockSection => 'Estoque';

  @override
  String get adminProductStockManage => 'Gerenciar estoque';

  @override
  String get adminProductStockHistory => 'Histórico de estoque';

  @override
  String get adminProductStockCurrent => 'Estoque atual';

  @override
  String get adminProductStockEmpty => 'Nenhuma movimentação de estoque';

  @override
  String get adminProductStockMove => 'Movimentar estoque';

  @override
  String get adminProductStockModeDelta => 'Entrada/Saída';

  @override
  String get adminProductStockModeAbsolute => 'Definir total';

  @override
  String get adminProductStockTypeIn => 'Entrada';

  @override
  String get adminProductStockTypeOut => 'Saída';

  @override
  String get adminProductStockQuantityField => 'Quantidade';

  @override
  String get adminProductStockQuantityInvalid =>
      'Informe uma quantidade válida';

  @override
  String get adminProductStockReason => 'Motivo';

  @override
  String get adminProductReasonPurchase => 'Compra';

  @override
  String get adminProductReasonReturn => 'Devolução';

  @override
  String get adminProductReasonManual => 'Ajuste manual';

  @override
  String get adminProductReasonLoss => 'Perda';

  @override
  String get adminProductStockNotes => 'Observações';

  @override
  String adminProductStockBeforeAfter(int before, int after) {
    return '$before → $after';
  }

  @override
  String get adminProductStockSaved => 'Estoque atualizado.';

  @override
  String get adminOrdersTitle => 'Pedidos';

  @override
  String get adminOrdersEmpty => 'Nenhum pedido encontrado';

  @override
  String get adminOrdersSearchHint => 'Buscar por nº do pedido';

  @override
  String get adminOrdersFiltersButton => 'Filtros';

  @override
  String get adminOrdersFiltersTitle => 'Filtros de pedidos';

  @override
  String get adminOrdersFiltersDeliveryType => 'Tipo de entrega';

  @override
  String get adminOrdersFilterAll => 'Todos';

  @override
  String get adminOrdersFilterDelivery => 'Entrega';

  @override
  String get adminOrdersFilterPickup => 'Retirada';

  @override
  String get adminOrdersFilterPeriod => 'Período';

  @override
  String get adminOrderStatusPending => 'Pendente';

  @override
  String get adminOrderStatusConfirmed => 'Confirmado';

  @override
  String get adminOrderStatusPreparing => 'Preparando';

  @override
  String get adminOrderStatusOutForDelivery => 'Em entrega';

  @override
  String get adminOrderStatusDelivered => 'Entregue';

  @override
  String get adminOrderStatusCancelled => 'Cancelado';

  @override
  String adminOrderDetailTitle(String number) {
    return 'Pedido #$number';
  }

  @override
  String get adminOrderCustomerSection => 'Cliente';

  @override
  String get adminOrderItemsSection => 'Itens do pedido';

  @override
  String get adminOrderPaymentSection => 'Pagamento';

  @override
  String get adminOrderHistorySection => 'Histórico de status';

  @override
  String get adminOrderDeliverySection => 'Entrega';

  @override
  String get adminOrderSubtotal => 'Subtotal';

  @override
  String get adminOrderDiscount => 'Desconto';

  @override
  String get adminOrderTotal => 'Total';

  @override
  String get adminOrderPickupLabel => 'Retirada no local';

  @override
  String get adminOrderDeliveryLabel => 'Entrega';

  @override
  String get adminOrderPaymentPending => 'Pendente';

  @override
  String get adminOrderPaymentPaid => 'Pago';

  @override
  String get adminOrderPaymentApproved => 'Aprovado';

  @override
  String get adminOrderPixCode => 'Código PIX';

  @override
  String adminOrderPixExpires(String date) {
    return 'Expira em $date';
  }

  @override
  String get adminOrderUpdateStatus => 'Atualizar status';

  @override
  String get adminOrderStatusNotes => 'Observações (opcional)';

  @override
  String get adminOrderStatusUpdated => 'Status atualizado.';

  @override
  String get adminOrderStatusUpdateError => 'Erro ao atualizar status.';

  @override
  String get adminOrderConfirm => 'Confirmar pedido';

  @override
  String get adminOrderStartPreparing => 'Iniciar preparo';

  @override
  String get adminOrderSendOut => 'Saiu para entrega';

  @override
  String get adminOrderMarkDelivered => 'Marcar como entregue';

  @override
  String get adminOrderCancel => 'Cancelar pedido';

  @override
  String get adminOrderAddItem => 'Adicionar produto';

  @override
  String get adminOrderEditItem => 'Editar item';

  @override
  String get adminOrderRemoveItem => 'Remover item';

  @override
  String get adminOrderRemoveItemConfirm => 'Remover este item do pedido?';

  @override
  String get adminOrderItemSaved => 'Item atualizado.';

  @override
  String get adminOrderItemAdded => 'Produto adicionado.';

  @override
  String get adminOrderItemRemoved => 'Item removido.';

  @override
  String get adminOrderSearchProduct => 'Buscar produto...';

  @override
  String get adminPromotionNew => 'Nova promoção';

  @override
  String get adminPromotionCreateTitle => 'Nova promoção';

  @override
  String get adminPromotionEditTitle => 'Editar promoção';

  @override
  String get adminPromotionsSearchHint => 'Buscar promoção';

  @override
  String get adminPromotionsEmpty => 'Nenhuma promoção encontrada';

  @override
  String get adminPromotionTypeLabel => 'Tipo de desconto';

  @override
  String get adminPromotionTypePercentage => 'Percentual (%)';

  @override
  String get adminPromotionTypeFixed => 'Valor fixo (R\$)';

  @override
  String get adminPromotionDiscountValue => 'Valor do desconto';

  @override
  String get adminPromotionStartsAt => 'Início';

  @override
  String get adminPromotionEndsAt => 'Término (opcional)';

  @override
  String get adminPromotionMinQuantity => 'Qtd. mínima';

  @override
  String get adminPromotionLinkedProducts => 'Produtos vinculados';

  @override
  String get adminPromotionAddProduct => 'Adicionar produto';

  @override
  String get adminPromotionUseLimit => 'Limite de usos';

  @override
  String adminPromotionUsesCount(int count) {
    return 'Usos: $count';
  }

  @override
  String get adminPromotionCreated => 'Promoção criada.';

  @override
  String get adminPromotionSaved => 'Promoção salva.';

  @override
  String get adminPromotionDeleted => 'Promoção removida.';

  @override
  String get adminPromotionDeleteConfirm => 'Remover esta promoção?';

  @override
  String get adminPromotionFilterActive => 'Ativas';

  @override
  String get adminPromotionFilterExpired => 'Expiradas';

  @override
  String get adminProductTabData => 'Dados';

  @override
  String get adminProductTabPromotions => 'Promoções';

  @override
  String get adminProductPromotionsEmpty => 'Nenhuma promoção vinculada';

  @override
  String get adminPromotionUseLimitHint => 'Sem limite';

  @override
  String get adminPromotionLinkButton => 'Vincular';

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
  String get loadMore => 'Carregar mais';

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
  String get deliveryHome => 'Receber em casa';

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

  @override
  String get cartEmpty => 'Seu carrinho está vazio';

  @override
  String get cartEmptySubtitle => 'Adicione produtos para continuar comprando';

  @override
  String get clearCart => 'Limpar carrinho';

  @override
  String get clearCartConfirm => 'Deseja remover todos os itens do carrinho?';

  @override
  String get cartCleared => 'Carrinho limpo';

  @override
  String get cartItemAdded => 'Adicionado ao carrinho';

  @override
  String get continueShopping => 'Continuar comprando';

  @override
  String get stockWarning => 'Alguns itens têm problemas de estoque';

  @override
  String get priceChanged => 'Preços de alguns itens foram alterados';

  @override
  String get checkoutTitle => 'Resumo do Pedido';

  @override
  String get checkoutDeliverySection => 'Como receber?';

  @override
  String get checkoutSelectAddress => 'Endereço de entrega';

  @override
  String get checkoutAddNewAddress => 'Cadastrar novo endereço';

  @override
  String get checkoutPayWithPix => 'Pagar com PIX';

  @override
  String checkoutPayWithMethod(String name) {
    return 'Pagar com $name';
  }

  @override
  String get checkoutPaymentMethod => 'Forma de pagamento';

  @override
  String get checkoutSelectPaymentMethod => 'Selecione como quer pagar';

  @override
  String get checkoutNoPaymentMethods => 'Nenhum método disponível';

  @override
  String get checkoutShippingFee => 'Frete';

  @override
  String get checkoutFreeShipping => 'Retirada gratuita';

  @override
  String get checkoutCepLabel => 'CEP de entrega';

  @override
  String get checkoutCepFound => 'Endereço encontrado!';

  @override
  String get checkoutCepNotFound => 'CEP não encontrado nos seus endereços';

  @override
  String get checkoutSaveAddress => 'Salvar endereço?';

  @override
  String get checkoutSaveAddressMessage =>
      'Deseja salvar este endereço na sua conta e torná-lo favorito?';

  @override
  String get checkoutUpdateAddress => 'Atualizar endereço salvo?';

  @override
  String get checkoutUpdateAddressMessage =>
      'Os dados foram alterados. Deseja atualizar o endereço salvo?';

  @override
  String get checkoutPlacing => 'Finalizando pedido...';

  @override
  String get checkoutValidating => 'Validando carrinho...';

  @override
  String get checkoutError => 'Erro ao finalizar pedido';

  @override
  String get checkoutCartChanged =>
      'Carrinho atualizado — revise os itens antes de continuar';

  @override
  String get pixTitle => 'Pagamento PIX';

  @override
  String get pixCopyCode => 'Copiar código';

  @override
  String get pixCopied => 'Código copiado!';

  @override
  String get pixExpiresIn => 'Expira em 30 minutos';

  @override
  String get pixSuccessTitle => 'Pedido criado!';

  @override
  String get pixSuccessSubtitle =>
      'Efetue o pagamento PIX para confirmar seu pedido';

  @override
  String get pixInstructions =>
      'Abra o app do seu banco, entre em Pix e cole o código abaixo';

  @override
  String get pixCodeLabel => 'Código PIX';

  @override
  String get orderSeeDetails => 'Ver detalhes completos';

  @override
  String get orderStatusHistory => 'Histórico de status';

  @override
  String get checkoutSavedAddresses => 'Endereços salvos';

  @override
  String get checkoutUseNewAddress => 'Usar outro endereço';

  @override
  String get checkoutDeliveryToSelected => 'Entrega para este endereço';
}
