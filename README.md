# Doglio - Pet Products Marketplace

A Flutter application for pet products sales, designed as a professional portfolio project.

## 🎯 Project Overview

Doglio is a comprehensive e-commerce marketplace specifically designed for pet products. This project demonstrates advanced Flutter development skills, clean architecture principles, and scalable code practices suitable for enterprise-level applications.

## ✨ Features

### 🛍️ Customer Features
- **Product Catalog**: Browse and search pet products with advanced filtering
- **Product Details**: Comprehensive product information with image galleries
- **Shopping Cart**: Add, remove, and manage products before purchase
- **Favorites**: Save products for later purchase
- **User Authentication**: Secure login and registration system
- **Order Management**: Track purchase history and order status
- **Internationalization**: Full support for English and Portuguese

### 🔧 Admin Features
- **Product Management**: Complete CRUD operations for products
- **Category Management**: Organize products into logical categories
- **Order Dashboard**: Monitor and manage customer orders
- **Image Upload**: Advanced image management system
- **Sales Analytics**: Track performance and sales metrics

## 🏗️ Architecture & Technical Excellence

### Clean Architecture Implementation
- **Domain Layer**: Business logic and entities
- **Data Layer**: Repository implementations and data sources
- **Presentation Layer**: UI components and state management

### Technical Stack
- **Frontend**: Flutter (Mobile + Web for admin)
- **Backend**: Laravel REST API (Authentication, Database, Storage)
- **State Management**: Simple ChangeNotifier (no external dependencies)
- **Navigation**: Custom routing with MaterialPageRoute
- **HTTP Client**: http package for API consumption
- **Architecture**: Clean Architecture (Domain/Data/Presentation)
- **Error Handling**: Custom exception hierarchy
- **Testing**: Unit, Widget, and Integration tests
- **Internationalization**: Flutter Intl (EN/PT)

### Code Quality Standards
- ✅ SOLID Principles implementation
- ✅ Repository Pattern for data abstraction
- ✅ Use Cases for business logic encapsulation
- ✅ Dependency Injection throughout the app
- ✅ Comprehensive error handling
- ✅ Performance optimizations
- ✅ Accessibility compliance
- ✅ Responsive design principles

## 📁 Project Structure

```
lib/
├── core/                    # Shared infrastructure
│   ├── config/             # Environment & DI setup
│   ├── errors/             # Error handling
│   ├── network/            # HTTP abstractions
│   ├── theme/              # Design system
│   ├── utils/              # Utilities & helpers
│   ├── shared/             # Shared widgets & models
│   └── l10n/               # Internationalization
├── features/               # Business features (Clean Architecture)
│   ├── auth/              # Authentication
│   ├── catalog/           # Product catalog
│   ├── cart/              # Shopping cart
│   ├── checkout/          # Purchase flow
│   └── profile/           # User management
├── app.dart               # App configuration
├── main.dart              # Entry point
└── router.dart            # Navigation setup
```

## 🚀 Development Roadmap

### Phase 1 - Infrastructure (Foundation)
- [x] Project structure setup
- [x] Clean Architecture implementation
- [x] Authentication system (Domain/Data/Presentation layers)
- [x] Laravel API datasource integration
- [ ] Laravel backend development
- [ ] Admin authentication
- [ ] Product CRUD (admin dashboard)

### Phase 2 - Public Catalog (Customer Experience)
- [ ] Product listing with pagination
- [ ] Advanced search and filtering
- [ ] Product details with image galleries
- [ ] Favorites system
- [ ] Shopping cart functionality

### Phase 3 - E-commerce (Complete Flow)
- [ ] Checkout process
- [ ] Payment integration
- [ ] Order management
- [ ] User profile and history
- [ ] Push notifications

### Phase 4 - Optimization & Deployment
- [ ] Performance optimization
- [ ] Comprehensive testing
- [ ] CI/CD pipeline
- [ ] App store deployment

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- PHP 8.1+ with Laravel (for backend)
- MySQL/PostgreSQL database
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/felipeggarcia/doglio.git
   cd doglio
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoint**
   - Edit `lib/core/config/api_config.dart`
   - Set `baseUrl` to your Laravel API URL (e.g., `http://localhost:8000` or `http://10.0.2.2:8000` for Android emulator)

4. **Run the application**
   ```bash
   flutter run
   ```

## 📱 Platforms Supported

- ✅ **Android** (Phone & Tablet)
- ✅ **iOS** (iPhone & iPad)
- ✅ **Web** (Admin Dashboard)
- 🚧 **macOS** (Future release)
- 🚧 **Windows** (Future release)

## 🤝 Contributing

This is a portfolio project, but feedback and suggestions are welcome! Please feel free to:

1. Open issues for bugs or feature requests
2. Submit pull requests for improvements
3. Share your thoughts on the architecture and implementation

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

**Felipe Garcia** - Senior Flutter Developer  
- GitHub: [@felipeggarcia](https://github.com/felipeggarcia)
- LinkedIn: [Your LinkedIn Profile]
- Email: [Your Email]

---

**Built with ❤️ and Flutter**

## 🎯 Project Context & Architecture

### About This Project
Doglio is a Flutter marketplace for pet products sales, developed as a professional portfolio project by a senior Flutter developer. The goal is to demonstrate advanced Flutter and Clean Architecture mastery, mobile development best practices, and implement a complete functional e-commerce platform with impeccable and scalable code.

### Architecture Philosophy
This project strictly follows **Clean Architecture** principles with clear separation of concerns:

- **Domain Layer**: Contains business logic, entities, and repository contracts (abstractions)
- **Data Layer**: Implements repositories, datasources, and data models
- **Presentation Layer**: UI components, pages, controllers, and state management

### Code Quality Standards
- **Clean Code**: Descriptive names, small focused functions, single responsibility
- **SOLID Principles**: Applied rigorously throughout the codebase
- **DRY**: Maximum code reuse, no duplication
- **Testability**: Designed for comprehensive test coverage
- **Documentation**: Inline documentation and detailed README
- **Performance**: Optimized builds, lazy loading, efficient caching

### Mandatory Development Conventions
1. **Pre-verification**: Always check if similar functionality already exists before creating new code
2. **Reusability**: Use existing widgets and functions before creating new ones
3. **Structure**: Strictly respect the defined folder structure
4. **Naming**: PascalCase for classes, snake_case for files
5. **Language**: Code and comments in English, UI supports EN/PT
6. **Constants**: Centralize all constants in appropriate config files
7. **Validation**: Always validate user inputs and handle errors gracefully

## 🔌 Backend Integration

### How It Works

This Flutter app is designed to integrate with a Laravel REST API backend. The integration follows Clean Architecture principles with clear separation of concerns:

**Architecture Layers:**
- **Domain Layer**: Defines business logic and repository contracts (interfaces)
- **Data Layer**: Implements datasources that consume the REST API endpoints
- **Presentation Layer**: UI components that use the business logic through Use Cases

**API Integration:**
- The app uses the `http` package to make REST API calls
- Authentication tokens are stored securely using `shared_preferences`
- All API calls include Bearer token authentication in headers
- The `LaravelAuthDatasource` handles all HTTP communication
- API base URL is configurable in `lib/core/config/api_config.dart`

**Key Features:**
- **Token Management**: Automatic token storage and injection in API requests
- **Error Handling**: Maps HTTP status codes to domain exceptions
- **Clean Architecture**: Datasource can be easily replaced without affecting business logic
- **Environment Configuration**: Support for dev, staging, and production environments

The backend should implement RESTful endpoints for authentication (login, register, logout, etc.) and return JSON responses with appropriate HTTP status codes. Bearer token authentication is used for protected routes.

---

# 🇧🇷 Versão em Português

# Doglio - Marketplace de Produtos Pet

Uma aplicação Flutter para venda de produtos para animais de estimação, projetada como um projeto de portfólio profissional.

## 🎯 Visão Geral do Projeto

Doglio é um marketplace de e-commerce completo, especificamente projetado para produtos pet. Este projeto demonstra habilidades avançadas de desenvolvimento Flutter, princípios de arquitetura limpa e práticas de código escalável adequadas para aplicações de nível empresarial.

## ✨ Funcionalidades

### 🛍️ Funcionalidades do Cliente
- **Catálogo de Produtos**: Navegue e pesquise produtos pet com filtragem avançada
- **Detalhes do Produto**: Informações completas do produto com galerias de imagens
- **Carrinho de Compras**: Adicione, remova e gerencie produtos antes da compra
- **Favoritos**: Salve produtos para compra posterior
- **Autenticação de Usuário**: Sistema seguro de login e registro
- **Gerenciamento de Pedidos**: Acompanhe histórico de compras e status dos pedidos
- **Internacionalização**: Suporte completo para Inglês e Português

### 🔧 Funcionalidades Admin
- **Gerenciamento de Produtos**: Operações CRUD completas para produtos
- **Gerenciamento de Categorias**: Organize produtos em categorias lógicas
- **Painel de Pedidos**: Monitore e gerencie pedidos de clientes
- **Upload de Imagens**: Sistema avançado de gerenciamento de imagens
- **Análise de Vendas**: Acompanhe desempenho e métricas de vendas

## 🏗️ Arquitetura & Excelência Técnica

### Implementação da Arquitetura Limpa
- **Camada de Domínio**: Lógica de negócio e entidades
- **Camada de Dados**: Implementações de repositório e fontes de dados
- **Camada de Apresentação**: Componentes de UI e gerenciamento de estado

### Stack Técnica
- **Frontend**: Flutter (Mobile + Web para admin)
- **Backend**: Laravel REST API (Autenticação, Banco de Dados, Storage)
- **Gerenciamento de Estado**: ChangeNotifier simples (sem dependências externas)
- **Navegação**: Roteamento customizado com MaterialPageRoute
- **Cliente HTTP**: Pacote http para consumo de API
- **Arquitetura**: Clean Architecture (Domínio/Dados/Apresentação)
- **Tratamento de Erros**: Hierarquia de exceções customizada
- **Testes**: Testes unitários, de Widget e de Integração
- **Internacionalização**: Flutter Intl (EN/PT)

### Padrões de Qualidade de Código
- ✅ Implementação dos Princípios SOLID
- ✅ Repository Pattern para abstração de dados
- ✅ Use Cases para encapsulamento de lógica de negócio
- ✅ Injeção de Dependência em toda a aplicação
- ✅ Tratamento de erros abrangente
- ✅ Otimizações de performance
- ✅ Conformidade com acessibilidade
- ✅ Princípios de design responsivo

## 📁 Estrutura do Projeto

```
lib/
├── core/                    # Infraestrutura compartilhada
│   ├── config/             # Configuração de ambiente & DI
│   ├── errors/             # Tratamento de erros
│   ├── network/            # Abstrações HTTP
│   ├── theme/              # Sistema de design
│   ├── utils/              # Utilitários & helpers
│   ├── shared/             # Widgets & modelos compartilhados
│   └── l10n/               # Internacionalização
├── features/               # Funcionalidades de negócio (Clean Architecture)
│   ├── auth/              # Autenticação
│   ├── catalog/           # Catálogo de produtos
│   ├── cart/              # Carrinho de compras
│   ├── checkout/          # Fluxo de compra
│   └── profile/           # Gerenciamento de usuário
├── app.dart               # Configuração do app
├── main.dart              # Ponto de entrada
└── router.dart            # Configuração de navegação
```

## 🚀 Roadmap de Desenvolvimento

### Fase 1 - Infraestrutura (Fundação)
- [x] Configuração da estrutura do projeto
- [x] Implementação da Clean Architecture
- [x] Sistema de autenticação (camadas Domínio/Dados/Apresentação)
- [x] Integração com datasource da API Laravel
- [ ] Desenvolvimento do backend Laravel
- [ ] Autenticação admin
- [ ] CRUD de produtos (painel admin)

### Fase 2 - Catálogo Público (Experiência do Cliente)
- [ ] Listagem de produtos com paginação
- [ ] Busca avançada e filtragem
- [ ] Detalhes do produto com galerias de imagens
- [ ] Sistema de favoritos
- [ ] Funcionalidade de carrinho de compras

### Fase 3 - E-commerce (Fluxo Completo)
- [ ] Processo de checkout
- [ ] Integração de pagamento
- [ ] Gerenciamento de pedidos
- [ ] Perfil de usuário e histórico
- [ ] Notificações push

### Fase 4 - Otimização & Deploy
- [ ] Otimização de performance
- [ ] Testes abrangentes
- [ ] Pipeline CI/CD
- [ ] Deploy nas lojas de aplicativos

## 🛠️ Começando

### Pré-requisitos
- Flutter SDK (3.0 ou superior)
- Dart SDK (3.0 ou superior)
- PHP 8.1+ com Laravel (para backend)
- Banco de dados MySQL/PostgreSQL
- Android Studio / VS Code
- Git

### Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/felipeggarcia/doglio.git
   cd doglio
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Configure o endpoint da API**
   - Edite `lib/core/config/api_config.dart`
   - Configure `baseUrl` para a URL da sua API Laravel (ex: `http://localhost:8000` ou `http://10.0.2.2:8000` para emulador Android)

4. **Execute a aplicação**
   ```bash
   flutter run
   ```

## 📱 Plataformas Suportadas

- ✅ **Android** (Phone & Tablet)
- ✅ **iOS** (iPhone & iPad)
- ✅ **Web** (Painel Admin)
- 🚧 **macOS** (Lançamento futuro)
- 🚧 **Windows** (Lançamento futuro)

## 🤝 Contribuindo

Este é um projeto de portfólio, mas feedback e sugestões são bem-vindos! Sinta-se à vontade para:

1. Abrir issues para bugs ou solicitações de funcionalidades
2. Enviar pull requests para melhorias
3. Compartilhar seus pensamentos sobre a arquitetura e implementação

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 📞 Contato

**Felipe Garcia** - Desenvolvedor Flutter Sênior  
- GitHub: [@felipeggarcia](https://github.com/felipeggarcia)
- LinkedIn: [Seu Perfil LinkedIn]
- Email: [Seu Email]

---

## 🎯 Contexto do Projeto & Arquitetura

### Sobre Este Projeto
Doglio é um marketplace Flutter para venda de produtos pet, desenvolvido como um projeto de portfólio profissional por um desenvolvedor Flutter sênior. O objetivo é demonstrar domínio avançado de Flutter e Clean Architecture, melhores práticas de desenvolvimento mobile, e implementar uma plataforma de e-commerce funcional e completa com código impecável e escalável.

### Filosofia da Arquitetura
Este projeto segue estritamente os princípios de **Clean Architecture** com clara separação de responsabilidades:

- **Camada de Domínio**: Contém lógica de negócio, entidades e contratos de repositório (abstrações)
- **Camada de Dados**: Implementa repositórios, datasources e modelos de dados
- **Camada de Apresentação**: Componentes de UI, páginas, controllers e gerenciamento de estado

### Padrões de Qualidade de Código
- **Código Limpo**: Nomes descritivos, funções pequenas e focadas, responsabilidade única
- **Princípios SOLID**: Aplicados rigorosamente em toda a base de código
- **DRY**: Máximo reuso de código, sem duplicação
- **Testabilidade**: Projetado para cobertura abrangente de testes
- **Documentação**: Documentação inline e README detalhado
- **Performance**: Builds otimizadas, lazy loading, cache eficiente

### Convenções Obrigatórias de Desenvolvimento
1. **Pré-verificação**: Sempre verifique se funcionalidade similar já existe antes de criar novo código
2. **Reusabilidade**: Use widgets e funções existentes antes de criar novas
3. **Estrutura**: Respeite estritamente a estrutura de pastas definida
4. **Nomenclatura**: PascalCase para classes, snake_case para arquivos
5. **Linguagem**: Código e comentários em inglês, UI suporta EN/PT
6. **Constantes**: Centralize todas as constantes em arquivos de configuração apropriados
7. **Validação**: Sempre valide entradas de usuário e trate erros graciosamente

## 🔌 Integração com Backend

### Como Funciona

Este app Flutter foi projetado para integrar com um backend Laravel REST API. A integração segue os princípios da Clean Architecture com clara separação de responsabilidades:

**Camadas da Arquitetura:**
- **Camada de Domínio**: Define a lógica de negócio e contratos de repositório (interfaces)
- **Camada de Dados**: Implementa datasources que consomem os endpoints da REST API
- **Camada de Apresentação**: Componentes de UI que usam a lógica de negócio através de Use Cases

**Integração com API:**
- O app usa o pacote `http` para fazer chamadas REST API
- Tokens de autenticação são armazenados de forma segura usando `shared_preferences`
- Todas as chamadas de API incluem autenticação Bearer token nos headers
- O `LaravelAuthDatasource` gerencia toda a comunicação HTTP
- A URL base da API é configurável em `lib/core/config/api_config.dart`

**Recursos Principais:**
- **Gerenciamento de Token**: Armazenamento automático de token e injeção nas requisições API
- **Tratamento de Erros**: Mapeia códigos de status HTTP para exceções de domínio
- **Clean Architecture**: Datasource pode ser facilmente substituído sem afetar a lógica de negócio
- **Configuração de Ambiente**: Suporte para ambientes dev, staging e produção

O backend deve implementar endpoints RESTful para autenticação (login, registro, logout, etc.) e retornar respostas JSON com códigos de status HTTP apropriados. Autenticação Bearer token é usada para rotas protegidas.

---

**Desenvolvido com ❤️ e Flutter**
