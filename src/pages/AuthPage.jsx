import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Eye, EyeOff, Info, Languages } from 'lucide-react';
import { useI18n } from '../core/i18n';
import { useStore } from '../app/store';
import { useToast } from '../core/components/Toast';
import Button from '../core/components/Button';
import { TextField } from '../core/components/Field';
import Logo from '../core/components/Logo';
import { isDemoAuth, validateConfirmPassword, validateFullName, validateIdentifier, validatePassword } from '../data/services/authService';

const EMPTY_LOGIN = { identifier: '', password: '' };
const EMPTY_REGISTER = { fullName: '', email: '', phone: '', password: '', confirmPassword: '' };

export default function AuthPage() {
  const { t, toggleLang } = useI18n();
  const { signIn, register } = useStore();
  const toast = useToast();
  const navigate = useNavigate();

  const [tab, setTab] = useState('login');
  const [loginValues, setLoginValues] = useState(EMPTY_LOGIN);
  const [registerValues, setRegisterValues] = useState(EMPTY_REGISTER);
  const [errors, setErrors] = useState({});
  const [formError, setFormError] = useState(null);
  const [notice, setNotice] = useState(null);
  const [pending, setPending] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  const isLogin = tab === 'login';

  const setLoginField = (field) => (event) => {
    setLoginValues((current) => ({ ...current, [field]: event.target.value }));
    if (errors[field]) setErrors((current) => ({ ...current, [field]: null }));
  };

  const setRegisterField = (field) => (event) => {
    setRegisterValues((current) => ({ ...current, [field]: event.target.value }));
    if (errors[field]) setErrors((current) => ({ ...current, [field]: null }));
  };

  const blurLogin = (field) => () => {
    if (field === 'identifier') {
      const key = loginValues.identifier ? validateIdentifier(loginValues.identifier) : null;
      setErrors((current) => ({ ...current, identifier: key }));
    }
    if (field === 'password') {
      const key = loginValues.password ? validatePassword(loginValues.password) : null;
      setErrors((current) => ({ ...current, password: key }));
    }
  };

  const blurRegister = (field) => () => {
    const checks = {
      fullName: registerValues.fullName ? validateFullName(registerValues.fullName) : null,
      email: registerValues.email ? validateIdentifier(registerValues.email) : null,
      phone: registerValues.phone ? validateIdentifier(registerValues.phone) : null,
      password: registerValues.password ? validatePassword(registerValues.password) : null,
      confirmPassword: registerValues.confirmPassword
        ? validateConfirmPassword(registerValues.password, registerValues.confirmPassword)
        : null,
    };
    setErrors((current) => ({ ...current, [field]: checks[field] ?? null }));
  };

  const handleLogin = async (event) => {
    event.preventDefault();
    const nextErrors = {
      identifier: validateIdentifier(loginValues.identifier),
      password: validatePassword(loginValues.password),
    };
    setErrors(nextErrors);
    if (Object.values(nextErrors).some(Boolean)) {
      setFormError('auth.errRequired');
      return;
    }
    setFormError(null);
    setPending(true);
    try {
      await signIn(loginValues);
      toast.show(t('auth.successLogin'), 'success');
      navigate('/', { replace: true });
    } catch (error) {
      setFormError(error?.i18nKey || 'auth.errCredentials');
    } finally {
      setPending(false);
    }
  };

  const handleRegister = async (event) => {
    event.preventDefault();
    const nextErrors = {
      fullName: validateFullName(registerValues.fullName),
      email: registerValues.email ? validateIdentifier(registerValues.email) : 'auth.errRequired',
      phone: registerValues.phone ? validateIdentifier(registerValues.phone) : 'auth.errRequired',
      password: validatePassword(registerValues.password),
      confirmPassword: validateConfirmPassword(registerValues.password, registerValues.confirmPassword),
    };
    setErrors(nextErrors);
    if (Object.values(nextErrors).some(Boolean)) {
      setFormError('auth.errRequired');
      return;
    }
    setFormError(null);
    setPending(true);
    try {
      await register(registerValues);
      toast.show(t('auth.registerNotice'), 'info');
      navigate('/', { replace: true });
    } catch (error) {
      setFormError(error?.i18nKey || 'auth.errAuthUnavailable');
    } finally {
      setPending(false);
    }
  };

  const handleForgot = () => {
    setNotice(t('auth.forgotNotice'));
    toast.show(t('auth.forgotNotice'), 'info');
  };

  return (
    <div className="auth-screen" data-component="auth-screen">
      <img
        className="auth-screen__bg"
        src="https://sc04.alicdn.com/kf/S7f882818ac584851b94acbc98c5e6aecz.jpg"
        alt=""
        aria-hidden="true"
        width="1024"
        height="1536"
      />
      <div className="auth-screen__scrim" aria-hidden="true" />

      <div className="auth-screen__top">
        <button type="button" className="lang-toggle" onClick={toggleLang} aria-label={t('auth.switchLanguage')}>
          <Languages size={18} aria-hidden="true" />
          <span>{t('meta.otherLangLabel')}</span>
        </button>
      </div>

      <section className="sheet auth-sheet" data-component="auth-sheet">
        <Logo size={48} />

        <div className="tabs" role="tablist" aria-label={t('auth.title')}>
          <button
            type="button"
            role="tab"
            aria-selected={isLogin}
            className={`tab ${isLogin ? 'is-active' : ''}`}
            onClick={() => {
              setTab('login');
              setErrors({});
              setFormError(null);
            }}
          >
            {t('auth.tabLogin')}
          </button>
          <button
            type="button"
            role="tab"
            aria-selected={!isLogin}
            className={`tab ${!isLogin ? 'is-active' : ''}`}
            onClick={() => {
              setTab('register');
              setErrors({});
              setFormError(null);
            }}
          >
            {t('auth.tabRegister')}
          </button>
        </div>

        <p className="auth-sheet__intro">{t('auth.intro')}</p>

        {formError ? (
          <div className="banner banner--error" role="alert">
            <span className="banner__icon" aria-hidden="true">
              <Info size={18} />
            </span>
            <div className="banner__content">
              <p className="banner__body">{t(formError)}</p>
            </div>
          </div>
        ) : null}

        {notice ? (
          <div className="banner banner--warn" role="status">
            <span className="banner__icon" aria-hidden="true">
              <Info size={18} />
            </span>
            <div className="banner__content">
              <p className="banner__body">{notice}</p>
            </div>
          </div>
        ) : null}

        {isLogin ? (
          <form className="form" onSubmit={handleLogin} noValidate>
            <TextField
              label={t('auth.emailOrPhone')}
              placeholder={t('auth.emailOrPhonePh')}
              value={loginValues.identifier}
              onChange={setLoginField('identifier')}
              onBlur={blurLogin('identifier')}
              error={errors.identifier ? t(errors.identifier) : null}
              forceLtr
              autoComplete="username"
              required
            />
            <div className="field-wrap">
              <TextField
                label={t('auth.password')}
                placeholder={t('auth.passwordPh')}
                type={showPassword ? 'text' : 'password'}
                value={loginValues.password}
                onChange={setLoginField('password')}
                onBlur={blurLogin('password')}
                error={errors.password ? t(errors.password) : null}
                forceLtr
                autoComplete="current-password"
                required
              />
              <button
                type="button"
                className="field__toggle"
                onClick={() => setShowPassword((value) => !value)}
                aria-label={showPassword ? t('auth.hidePassword') : t('auth.showPassword')}
              >
                {showPassword ? <EyeOff size={18} aria-hidden="true" /> : <Eye size={18} aria-hidden="true" />}
              </button>
            </div>

            <Button type="submit" block loading={pending} loadingLabel={t('auth.loggingIn')}>
              {t('auth.login')}
            </Button>

            <div className="auth-sheet__links">
              <button type="button" className="btn btn--link" onClick={handleForgot}>
                {t('auth.forgot')}
              </button>
            </div>

            <Button variant="secondary" block disabled={pending} onClick={() => setTab('register')}>
              {t('auth.createAccount')}
            </Button>
          </form>
        ) : (
          <form className="form" onSubmit={handleRegister} noValidate>
            <TextField
              label={t('auth.fullName')}
              placeholder={t('auth.fullNamePh')}
              value={registerValues.fullName}
              onChange={setRegisterField('fullName')}
              onBlur={blurRegister('fullName')}
              error={errors.fullName ? t(errors.fullName) : null}
              autoComplete="name"
              required
            />
            <TextField
              label={t('auth.email')}
              placeholder={t('auth.emailPh')}
              type="email"
              value={registerValues.email}
              onChange={setRegisterField('email')}
              onBlur={blurRegister('email')}
              error={errors.email ? t(errors.email) : null}
              forceLtr
              autoComplete="email"
              required
            />
            <TextField
              label={t('auth.phone')}
              placeholder={t('auth.phonePh')}
              value={registerValues.phone}
              onChange={setRegisterField('phone')}
              onBlur={blurRegister('phone')}
              error={errors.phone ? t(errors.phone) : null}
              forceLtr
              inputMode="tel"
              autoComplete="tel"
              required
            />
            <TextField
              label={t('auth.password')}
              placeholder={t('auth.passwordPh')}
              type={showPassword ? 'text' : 'password'}
              value={registerValues.password}
              onChange={setRegisterField('password')}
              onBlur={blurRegister('password')}
              error={errors.password ? t(errors.password) : null}
              forceLtr
              autoComplete="new-password"
              required
            />
            <TextField
              label={t('auth.confirmPassword')}
              type={showPassword ? 'text' : 'password'}
              value={registerValues.confirmPassword}
              onChange={setRegisterField('confirmPassword')}
              onBlur={blurRegister('confirmPassword')}
              error={errors.confirmPassword ? t(errors.confirmPassword) : null}
              forceLtr
              autoComplete="new-password"
              required
            />

            <Button type="submit" block loading={pending} loadingLabel={t('auth.creatingAccount')}>
              {t('auth.createAccount')}
            </Button>
          </form>
        )}

        {isDemoAuth ? (
          <div className="banner banner--warn" data-component="dev-mode-notice">
            <span className="banner__icon" aria-hidden="true">
              <Info size={18} />
            </span>
            <div className="banner__content">
              <p className="banner__title">{t('auth.devModeTitle')}</p>
              <p className="banner__body">{t('auth.devModeBody')}</p>
              <p className="banner__meta" dir="ltr">
                {t('auth.devCredential')}
              </p>
            </div>
          </div>
        ) : null}

        <p className="auth-sheet__fineprint">{t('auth.credentialsNote')}</p>
      </section>
    </div>
  );
}
