<?php
/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information
 * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', getenv('DB_NAME'));

/** MySQL database username */
define('DB_USER', getenv('DB_USER'));

/** MySQL database password */
define('DB_PASSWORD', getenv('DB_PASS'));

/** MySQL hostname */
define('DB_HOST', getenv('DB_HOST').":".getenv('DB_PORT'));

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '--w,=nO-t>g:EOH>e-ZXs!7x(: W4:}1A2$E?Sn9P>TW-[=:u[nc-eQ<vIi<6|wh');
define('SECURE_AUTH_KEY',  'PlM~WQ/9-~V:-3&be`nxuaghz@JyN!]SzVr_]lAM2b?QH(d(|`.z_;1jIE4kY&f+');
define('LOGGED_IN_KEY',    'K]6*uCb-m~>zj5C1krtu:>2VT(WlI/Jl5T~Pov2-`r+Zb5s3i6&aIN$*/+k/~sLN');
define('NONCE_KEY',        '~; xvP`h^{Pl9zaD#/!f@M21BAk0#sKg>*P+=1LV+FY+;HNE)%Y`4(Xq|&})fCj^');
define('AUTH_SALT',        'A2|G[jvSLB+z dy S/ S>(lLyzxDvJ8(ps1(F%~x]eRD`UHv(h*IDjye+SYV-a;O');
define('SECURE_AUTH_SALT', '9cv/Hy~a;qr]4)i*udy-/$non@_:CU0SIdm-L[WH^k_}s:Jq[)HV,Wu8na<_;ef3');
define('LOGGED_IN_SALT',   '{d*4OCrk9x`|cb-4EBK7=ewJ3D]y%z,7mSEd:8?=eP![zD.O`<Uubt-u%@TA+x T');
define('NONCE_SALT',       'z6G5thFC]JIW]|ZQIBgZ?zBb^!N#3-Un=)`!Xb/,Yd8[2&}.W{ITu?=PE0oZ,<8^');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress. A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
 * language support.
 */
define('WPLANG', '');

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');

/** change permisssions for plugin installation */
define("FS_METHOD","direct");
define("FS_CHMOD_DIR", 0777);
define("FS_CHMOD_FILE", 0777);
