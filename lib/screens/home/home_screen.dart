import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../controllers/cleaning_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../models/album_info.dart';
import '../../models/order_mode.dart';
import '../../models/photo_permission.dart';
import '../../services/photo_service.dart';
import '../../widgets/photo_thumbnail.dart';
import '../../widgets/settings_drawer.dart';
import '../cleaning/cleaning_screen.dart';

/// App home: brand header + album grid (no separate Start screen).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.settings, this.photoService});

  final SettingsController settings;
  final PhotoService? photoService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final PhotoService _photoService = widget.photoService ?? PhotoService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final AnimationController _menuIconController;

  PhotoPermission _permission = PhotoPermission.unknown;
  bool _checkingPermission = true;
  bool _starting = false;
  Future<List<AlbumInfo>>? _albumsFuture;

  @override
  void initState() {
    super.initState();
    _menuIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _bootstrap();
  }

  @override
  void dispose() {
    _menuIconController.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    setState(() => _checkingPermission = true);
    final permission = await _photoService.currentPermission();
    if (!mounted) return;

    setState(() {
      _permission = permission;
      _checkingPermission = false;
      if (permission.hasAccess) {
        _albumsFuture = _photoService.getAlbums();
      } else {
        _albumsFuture = null;
      }
    });
  }

  Future<void> _requestAccess() async {
    final permission = await _photoService.requestPermission();
    if (!mounted) return;
    setState(() {
      _permission = permission;
      if (permission.hasAccess) {
        _albumsFuture = _photoService.getAlbums();
      }
    });
  }

  Future<void> _reloadAlbums() async {
    setState(() {
      _albumsFuture = _photoService.getAlbums();
    });
  }

  void _toggleDrawer() {
    final scaffold = _scaffoldKey.currentState;
    if (scaffold == null) return;
    if (scaffold.isDrawerOpen) {
      scaffold.closeDrawer();
    } else {
      scaffold.openDrawer();
    }
  }

  Future<void> _onAlbumTap(AlbumInfo album) async {
    if (_starting) return;

    final mode = await showModalBottomSheet<OrderMode>(
      context: context,
      showDragHandle: true,
      builder: (context) => _OrderBottomSheet(albumName: album.name),
    );

    if (mode == null || !mounted) return;
    await _startSession(album, mode);
  }

  Future<void> _startSession(AlbumInfo album, OrderMode mode) async {
    setState(() => _starting = true);
    final l10n = AppLocalizations.of(context);

    try {
      final photos = await _photoService.getPhotosForAlbum(album.id);
      if (!mounted) return;

      if (photos.isEmpty) {
        setState(() => _starting = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.albumEmpty)));
        return;
      }

      final controller = CleaningController(
        album: album,
        orderMode: mode,
        photos: photos,
      );

      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CleaningScreen(
            controller: controller,
            photoService: _photoService,
            settings: widget.settings,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.albumLoadFailed)));
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: SettingsDrawer(settings: widget.settings),
      onDrawerChanged: (isOpened) {
        if (isOpened) {
          _menuIconController.forward();
        } else {
          _menuIconController.reverse();
        }
      },
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.md,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: _toggleDrawer,
                        tooltip: _menuIconController.value > 0.5
                            ? l10n.closeMenu
                            : l10n.openMenu,
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.menu_close,
                          progress: _menuIconController,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.sm),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.appTitle,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                l10n.appTagline,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: _buildBody(theme, l10n)),
              ],
            ),
            if (_starting)
              const ColoredBox(
                color: Color(0x66000000),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, AppLocalizations l10n) {
    if (_checkingPermission) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_permission.hasAccess) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _permissionMessage(_permission, l10n),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: _requestAccess,
              child: Text(l10n.allowAccess),
            ),
            if (_permission == PhotoPermission.permanentlyDenied ||
                _permission == PhotoPermission.denied) ...[
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () => _photoService.openSettings(),
                child: Text(l10n.openSettings),
              ),
            ],
          ],
        ),
      );
    }

    return FutureBuilder<List<AlbumInfo>>(
      future: _albumsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _MessageBody(
            title: l10n.couldNotLoadAlbums,
            body: l10n.checkPhotoPermissions,
            actionLabel: l10n.tryAgain,
            onAction: _reloadAlbums,
          );
        }
        final albums = snapshot.data ?? const [];
        if (albums.isEmpty) {
          return _MessageBody(
            title: l10n.noPhotosToReview,
            body: l10n.noAccessiblePhotos,
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.78,
          ),
          itemCount: albums.length,
          itemBuilder: (context, index) {
            final album = albums[index];
            return _AlbumTile(
              album: album,
              photoService: _photoService,
              photoCountLabel: l10n.photoCount(album.assetCount),
              onTap: () => _onAlbumTap(album),
            );
          },
        );
      },
    );
  }

  String _permissionMessage(PhotoPermission permission, AppLocalizations l10n) {
    switch (permission) {
      case PhotoPermission.permanentlyDenied:
        return l10n.permissionPermanentlyDenied;
      case PhotoPermission.denied:
      case PhotoPermission.unknown:
        return l10n.permissionNeeded;
      case PhotoPermission.limited:
      case PhotoPermission.granted:
        return '';
    }
  }
}

class _OrderBottomSheet extends StatelessWidget {
  const _OrderBottomSheet({required this.albumName});

  final String albumName;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    String title(OrderMode mode) {
      switch (mode) {
        case OrderMode.newestFirst:
          return l10n.orderNewestTitle;
        case OrderMode.oldestFirst:
          return l10n.orderOldestTitle;
        case OrderMode.random:
          return l10n.orderRandomTitle;
      }
    }

    String subtitle(OrderMode mode) {
      switch (mode) {
        case OrderMode.newestFirst:
          return l10n.orderNewestSubtitle;
        case OrderMode.oldestFirst:
          return l10n.orderOldestSubtitle;
        case OrderMode.random:
          return l10n.orderRandomSubtitle;
      }
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.chooseOrder,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              albumName,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.md),
            for (final mode in OrderMode.values)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(title(mode)),
                subtitle: Text(subtitle(mode)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).pop(mode),
              ),
          ],
        ),
      ),
    );
  }
}

class _AlbumTile extends StatelessWidget {
  const _AlbumTile({
    required this.album,
    required this.photoService,
    required this.photoCountLabel,
    required this.onTap,
  });

  final AlbumInfo album;
  final PhotoService photoService;
  final String photoCountLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: album.coverAssetId == null
                    ? ColoredBox(
                        color: scheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.photo_library_outlined,
                          color: scheme.onSurfaceVariant,
                          size: 40,
                        ),
                      )
                    : PhotoThumbnail(
                        photoId: album.coverAssetId!,
                        photoService: photoService,
                        size: 500,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              album.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              photoCountLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBody extends StatelessWidget {
  const _MessageBody({
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            body,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
