
abstract class Links {

  //usuario
  static const String LOGIN = "usuarios/login/";
  static const String REGISTER = "usuarios/cadastroapp/";
  static const String UPDATE_USER_DATA = "usuarios/updateUser/";
  static const String LOAD_PROFILE = "usuarios/perfil/";
  static const String UPDATE_AVATAR = "usuarios/updateavatar/";
  static const String UPDATE_PASSWORD = "usuarios/atualizar_senha/";
  static const String DISABLE_ACCOUNT = "usuarios/desativarconta/";
  static const String SAVE_FCM = "usuarios/savefcm/";
  static const String LIST_NOTIFICATIONS = "usuarios/notificacoes/";

  //produtos
  static const String LIST_CATEGORIES = "produtos/list_categorias/";
  static const String LIST_SUBCATEGORIES = "produtos/list_subcategorias/";
  static const String LIST_PRODUCTS = "produtos/list_produtos/";
  static const String LOAD_PRODUCT = "produtos/list_produtosDetalhes/";
  static const String LIST_HIGHLIGHTS = "produtos/list_produtosDest/";
  static const String FILTER_PRODUCTS = "produtos/list_produtosFiltro/";

  //enderecos
  static const String SAVE_ADDRESS = "usuarios/saveendereco/";
  static const String LIST_ADDRESSES = "usuarios/listAllEnderecos/";
  static const String FIND_ADDRESS = "usuarios/findEndereco/";
  static const String UPDATE_ADDRESS = "usuarios/updateEndereco/";
  static const String DELETE_ADDRESS = "usuarios/deleteEndereco/";

  //favoritos
  static const String ADD_FAVORITE = "favoritos/add_favoritos/";
  static const String LIST_FAVORITES = "favoritos/list_favoritos/";
  static const String DELETE_FAVORITE = "favoritos/delete_favoritos/";

  //carrinho
  static const String OPENED_CART = "carrinho/carrinho_aberto/";
  static const String ADD_ITEM_CART = "carrinho/add_item_carrinho/";
  static const String UPDATE_ITEM_CART = "carrinho/update_item_carrinho";
  static const String LIST_CART_ITEMS = "carrinho/list_itens_carrinho/";
  static const String DELETE_ITEM_CART = "carrinho/delete_item_carrinho/";

  //frete
  static const String CALCULE_FREIGHT = "frete/calcular_frete/";

  //orders
  static const String FIND_WITHDRAWAL = "pedidos/find_retirada/";
  static const String FIND_WITHDRAWAL_TIME = "pedidos/find_retirada_time/";
  static const String LIST_ORDERS = "pedidos/list_pedidos/";
  static const String ADD_ORDER = "pedidos/add_pedido/";
  static const String FIND_ORDER = "pedidos/find_pedido/";

  //pagamentos
  static const String ADD_PAYMENT = "pagamentos/adicionar/";
  static const String LIST_PAYMENTS = "pagamentos/listar/";
  static const String CREATE_TOKEN_CARD = "pagamentos/criarTokenCartao/";



}